#ifndef HEAT_SURFACE_COUPLED_HPP
#define HEAT_SURFACE_COUPLED_HPP

#include <memory>
#include <string>
#include <typeinfo>

#include <cadmium/modeling/celldevs/grid/coupled.hpp>

#include "heat_diffusion_cell.hpp"

using namespace cadmium::celldevs;

inline std::shared_ptr<GridCell<HeatDiffusionState, double>> addHeatGridCell(
    const coordinates& cellId,
    const std::shared_ptr<const GridCellConfig<HeatDiffusionState, double>>& cellConfig
) {
    const auto& cellModel = cellConfig->cellModel;

    if (cellModel == "heat_diffusion" || cellModel == "HeatDiffusionCell") {
        return std::make_shared<HeatDiffusionCell>(cellId, cellConfig);
    }

    throw std::bad_typeid();
}

struct HeatSurfaceCoupled : public GridCellDEVSCoupled<HeatDiffusionState, double> {
    cadmium::Port<int> inputHeat;
    cadmium::Port<int> inputCold;

    explicit HeatSurfaceCoupled(const std::string& id, const std::string& configFilePath)
        : GridCellDEVSCoupled<HeatDiffusionState, double>(id, addHeatGridCell, configFilePath) {
        inputHeat = addInPort<int>("inputHeat");
        inputCold = addInPort<int>("inputCold");

        buildModel();
    }
};

#endif
