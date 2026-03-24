#include <iostream>
#include <memory>
#include <string>

#include <cadmium/simulation/logger/csv.hpp>
#include <cadmium/simulation/root_coordinator.hpp>

#include "heat_diffusion_top.hpp"

using namespace cadmium;

int main(int argc, char** argv) {
    if (argc < 2) {
        std::cout << "Usage: " << argv[0]
                  << " CONFIG.json [MAX_SIMULATION_TIME=250] "
                  << "[CSV_OUTPUT=simulation_results/heat_diffusion_top_grid_log.csv]"
                  << std::endl;
        return -1;
    }

    const std::string configFilePath = argv[1];
    const double simTime = (argc > 2) ? std::stod(argv[2]) : 250.0;
    const std::string outputCsv = (argc > 3)
        ? argv[3]
        : "simulation_results/heat_diffusion_top_grid_log.csv";

    auto model = std::make_shared<HeatDiffusionTop>(
        "HeatDiffusionTop",
        configFilePath
    );

    auto rootCoordinator = RootCoordinator(model);
    rootCoordinator.setLogger<CSVLogger>(outputCsv, ";");

    rootCoordinator.start();
    rootCoordinator.simulate(simTime);
    rootCoordinator.stop();

    return 0;
}
