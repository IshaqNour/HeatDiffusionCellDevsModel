#ifndef TRIGGER_GENERATOR_HPP
#define TRIGGER_GENERATOR_HPP

#include <limits>
#include <ostream>
#include <random>
#include <string>

#include <cadmium/modeling/devs/atomic.hpp>

struct TriggerGeneratorState {
    int token;
    double sigma;

    TriggerGeneratorState()
        : token(1),
          sigma(std::numeric_limits<double>::infinity()) {}
};

inline std::ostream& operator<<(std::ostream& os, const TriggerGeneratorState& s) {
    os << "{token:" << s.token << ",sigma:" << s.sigma << "}";
    return os;
}

inline double sampleInitialTriggerDelay(unsigned seed, double meanSeconds) {
    std::mt19937 randomEngine(seed);
    std::exponential_distribution<double> distribution(1.0 / meanSeconds);
    const double sample = distribution(randomEngine);
    return (sample > 0.0) ? sample : std::numeric_limits<double>::epsilon();
}

inline TriggerGeneratorState makeInitialTriggerGeneratorState(unsigned seed, double meanSeconds) {
    TriggerGeneratorState state;
    state.sigma = sampleInitialTriggerDelay(seed, meanSeconds);
    return state;
}

class TriggerGenerator : public cadmium::Atomic<TriggerGeneratorState> {
public:
    cadmium::Port<int> out;

protected:
    mutable std::mt19937 randomEngine;
    mutable std::exponential_distribution<double> interArrivalDistribution;

    [[nodiscard]] double sampleNextDelay() const {
        const double sample = interArrivalDistribution(randomEngine);
        return (sample > 0.0) ? sample : std::numeric_limits<double>::epsilon();
    }

    explicit TriggerGenerator(
        const std::string& id,
        unsigned seed,
        double meanSeconds = 50.0
    )
        : cadmium::Atomic<TriggerGeneratorState>(id, makeInitialTriggerGeneratorState(seed, meanSeconds)),
          randomEngine(seed),
          interArrivalDistribution(1.0 / meanSeconds) {
        out = addOutPort<int>("out");
        (void)interArrivalDistribution(randomEngine);
    }

public:
    void externalTransition(TriggerGeneratorState& state, double e) const override {
        (void)state;
        (void)e;
    }

    void output(const TriggerGeneratorState& state) const override {
        out->addMessage(state.token);
    }

    void internalTransition(TriggerGeneratorState& state) const override {
        state.token = 1;
        state.sigma = sampleNextDelay();
    }

    void confluentTransition(TriggerGeneratorState& state, double e) const override {
        (void)e;
        internalTransition(state);
    }

    [[nodiscard]] double timeAdvance(const TriggerGeneratorState& state) const override {
        return state.sigma;
    }
};

class HeatGenerator : public TriggerGenerator {
public:
    explicit HeatGenerator(const std::string& id)
        : TriggerGenerator(id, 5104u) {}
};

class ColdGenerator : public TriggerGenerator {
public:
    explicit ColdGenerator(const std::string& id)
        : TriggerGenerator(id, 101235384u) {}
};

#endif
