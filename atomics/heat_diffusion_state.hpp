#ifndef HEAT_DIFFUSION_STATE_HPP
#define HEAT_DIFFUSION_STATE_HPP

#include <cmath>
#include <iomanip>
#include <iostream>

#include <nlohmann/json.hpp>

struct HeatDiffusionState {
    double temperature;

    explicit HeatDiffusionState(double initialTemperature = 24.0)
        : temperature(initialTemperature) {}
};

inline bool operator!=(const HeatDiffusionState& x, const HeatDiffusionState& y) {
    return std::fabs(x.temperature - y.temperature) > 1e-9;
}

inline std::ostream& operator<<(std::ostream& os, const HeatDiffusionState& x) {
    const auto previousFlags = os.flags();
    const auto previousPrecision = os.precision();

    os << "<" << std::fixed << std::setprecision(3) << x.temperature << ">";

    os.flags(previousFlags);
    os.precision(previousPrecision);
    return os;
}

inline void from_json(const nlohmann::json& j, HeatDiffusionState& s) {
    j.at("temperature").get_to(s.temperature);
}

#endif

