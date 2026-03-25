#ifndef HEAT_DIFFUSION_CELL_HPP
#define HEAT_DIFFUSION_CELL_HPP

#include <cstddef>
#include <random>
#include <unordered_map>
#include <vector>

#include <cadmium/modeling/celldevs/grid/cell.hpp>
#include <cadmium/modeling/celldevs/grid/config.hpp>

#include "heat_diffusion_state.hpp"

using namespace cadmium::celldevs;

class HeatDiffusionCell : public GridCell<HeatDiffusionState, double> {
public:
    cadmium::Port<int> inputHeat;
    cadmium::Port<int> inputCold;

private:
    bool hotSourceCell;
    bool coldSourceCell;
    double cellDelay;
    double hotMin;
    double hotMax;
    double coldMin;
    double coldMax;
    mutable std::mt19937 randomEngine;
    mutable std::uniform_real_distribution<double> hotDistribution;
    mutable std::uniform_real_distribution<double> coldDistribution;

    static unsigned buildSeed(const std::vector<int>& id, bool isHotSource, bool isColdSource) {
        unsigned seed = 5104u;

        for (const int coordinate : id) {
            seed = (seed * 131u) + static_cast<unsigned>(coordinate + 97);
        }

        if (isHotSource) {
            seed += 11u;
        }

        if (isColdSource) {
            seed += 29u;
        }

        return seed;
    }

public:
    HeatDiffusionCell(
        const std::vector<int>& id,
        const std::shared_ptr<const GridCellConfig<HeatDiffusionState, double>>& config
    )
        : GridCell<HeatDiffusionState, double>(id, config),
          hotSourceCell(false),
          coldSourceCell(false),
          cellDelay(1.0),
          hotMin(24.0),
          hotMax(40.0),
          coldMin(-10.0),
          coldMax(15.0),
          randomEngine(5104u),
          hotDistribution(24.0, 40.0),
          coldDistribution(-10.0, 15.0) {
        inputHeat = addInPort<int>("inputHeat");
        inputCold = addInPort<int>("inputCold");

        const auto& rawConfig = config->rawCellConfig;
        if (rawConfig.is_object()) {
            if (rawConfig.contains("hot_source_cell")) {
                rawConfig.at("hot_source_cell").get_to(hotSourceCell);
            }
            if (rawConfig.contains("cold_source_cell")) {
                rawConfig.at("cold_source_cell").get_to(coldSourceCell);
            }
            if (rawConfig.contains("output_delay")) {
                rawConfig.at("output_delay").get_to(cellDelay);
            }
            if (rawConfig.contains("hot_min")) {
                rawConfig.at("hot_min").get_to(hotMin);
            }
            if (rawConfig.contains("hot_max")) {
                rawConfig.at("hot_max").get_to(hotMax);
            }
            if (rawConfig.contains("cold_min")) {
                rawConfig.at("cold_min").get_to(coldMin);
            }
            if (rawConfig.contains("cold_max")) {
                rawConfig.at("cold_max").get_to(coldMax);
            }
        }

        randomEngine.seed(buildSeed(id, hotSourceCell, coldSourceCell));
        hotDistribution = std::uniform_real_distribution<double>(hotMin, hotMax);
        coldDistribution = std::uniform_real_distribution<double>(coldMin, coldMax);
    }

    [[nodiscard]] HeatDiffusionState localComputation(
        HeatDiffusionState state,
        const std::unordered_map<std::vector<int>, NeighborData<HeatDiffusionState, double>>& neighborhood
    ) const override {
        if (neighborhood.empty()) {
            return state;
        }

        double accumulatedTemperature = 0.0;
        std::size_t neighborCount = 0;

        for (const auto& [neighborId, neighborData] : neighborhood) {
            (void)neighborId;
            const auto nState = neighborData.state;
            if (nState != nullptr) {
                accumulatedTemperature += nState->temperature;
                ++neighborCount;
            }
        }

        if (neighborCount > 0) {
            state.temperature = accumulatedTemperature / static_cast<double>(neighborCount);
        }

        return state;
    }

    void externalTransition(double e) override {
        this->clock += e;
        this->sigma -= e;

        for (const auto& msg : this->inputNeighborhood->getBag()) {
            this->neighborhood.at(msg->cellId).state = msg->state;
        }

        HeatDiffusionState nextState = this->state;

        if (hotSourceCell && !inputHeat->empty()) {
            nextState.temperature = hotDistribution(randomEngine);
        } else if (coldSourceCell && !inputCold->empty()) {
            nextState.temperature = coldDistribution(randomEngine);
        } else {
            nextState = localComputation(this->state, this->neighborhood);
        }

        if (nextState != this->state) {
            this->outputQueue->addToQueue(nextState, this->clock + outputDelay(nextState));
            this->sigma = this->outputQueue->nextTime() - this->clock;
        }

        this->state = nextState;
    }

    [[nodiscard]] double outputDelay(const HeatDiffusionState& state) const override {
        (void)state;
        return cellDelay;
    }
};

#endif
