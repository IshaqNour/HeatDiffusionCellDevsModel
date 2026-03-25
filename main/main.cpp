#include <iostream>
#include <memory>
#include <string>

#include <cadmium/simulation/logger/csv.hpp>
#include <cadmium/simulation/root_coordinator.hpp>

#include "heat_diffusion_top.hpp"

using namespace cadmium;

int main(int argc, char** argv) {
    const std::string configFilePath = (argc > 1)
        ? argv[1]
        : "config/heat_config_base_scenario.json";
    const double simTime = (argc > 2) ? std::stod(argv[2]) : 250.0;

    auto model = std::make_shared<HeatDiffusionTop>("HeatDiffusionTop", configFilePath);

    auto rootCoordinator = RootCoordinator(model);
    rootCoordinator.setLogger<CSVLogger>("log/heat_diffusion_log.csv", ";");

    rootCoordinator.start();
    rootCoordinator.simulate(simTime);
    rootCoordinator.stop();

    return 0;
}