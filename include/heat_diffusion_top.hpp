#ifndef HEAT_DIFFUSION_TOP_HPP
#define HEAT_DIFFUSION_TOP_HPP

#include <string>

#include <cadmium/modeling/devs/coupled.hpp>

#include "trigger_generator.hpp"
#include "heat_surface_coupled.hpp"

struct HeatDiffusionTop : public cadmium::Coupled {
    explicit HeatDiffusionTop(const std::string& id, const std::string& configFilePath)
        : cadmium::Coupled(id) {
        auto heatSurface = addComponent<HeatSurfaceCoupled>("HeatSurfaceCoupled", configFilePath);
        auto heatGenerator = addComponent<HeatGenerator>("HeatGenerator");
        auto coldGenerator = addComponent<ColdGenerator>("ColdGenerator");

        addCoupling(heatGenerator->out, heatSurface->inputHeat);
        addCoupling(coldGenerator->out, heatSurface->inputCold);
    }
};

#endif
