# Heat Diffusion Cell-DEVS Model

## Overview
This repository contains the Cadmium implementation of the Assignment 2 heat diffusion model. The simulation uses a wrapped 10x10 Cell-DEVS grid, external hot and cold trigger inputs, and four experiment configurations:
- baseline
- hotter source
- reduced cooling
- nonuniform initial condition

The C++ model logic is kept in the `include/` and `main/` folders. The shell scripts at the repository root are the intended way to build and run the experiments.

## Project Layout
- `include/`: cell state, cell behavior, trigger generators, and the top coupled model
- `main/`: simulation entry point and CMake target definition
- `config/`: experiment JSON files and the web-viewer JSON file
- `log/`: generated CSV logs for the experiments
- `Simulation_videos/`: place to store recorded viewer runs for the report
- `build_sim.sh`: rebuilds the simulator
- `run_*_scenario.sh`: builds and runs each experiment

## Project Notes
- `build/` and `bin/` are generated during compilation.
- The repository is intended to be run through the root shell scripts rather than by invoking the executable manually.
- If `cmake` or `make` is missing, install them before running the build script.
- If `CADMIUM` is not set correctly, CMake will fail during configuration.
- On Windows-like shells, `build_sim.sh` automatically chooses a compatible CMake generator so the documented commands stay the same.

## Build Requirements
The project expects Cadmium v2 to be available through the `CADMIUM` environment variable.

You also need:
- `cmake` available from the shell PATH
- `make`
- a C++17-compatible compiler
- a shell environment that can run `.sh` scripts

If `cadmium_v2` is cloned beside this repository, a typical setup is:

```bash
export CADMIUM=../cadmium_v2/include
```

## Building
From the repository root:
```bash
./build_sim.sh
```

You can also use:
```bash
bash build_sim.sh
```

The compiled executable is placed in `bin/`.

## Running The Experiments
Each scenario has its own runner script. These scripts rebuild the simulator, execute the selected configuration, and save a filtered CSV in `log/`.

```bash
./run_base_scenario.sh
./run_hotter_source_scenario.sh
./run_reduced_cooling_scenario.sh
./run_nonuniform_initial_scenario.sh
```

If needed, the same scripts can be launched with `bash` explicitly:
```bash
bash run_base_scenario.sh
```

## Scenario Files
The experiment inputs are defined in:
- `config/heat_config_base_scenario.json`
- `config/heat_config_hotter_source.json`
- `config/heat_config_reduced_cooling.json`
- `config/heat_config_nonuniform_initial.json`

The viewer configuration is:
- `config/heat_diffusionVisualization_config.json`

## Output Logs
After running the scripts, the generated logs are stored in `log/`:
- `heat_diffusion_base_scenario_log.csv`
- `heat_diffusion_hotter_source_log.csv`
- `heat_diffusion_reduced_cooling_log.csv`
- `heat_diffusion_nonuniform_initial_log.csv`

These files are the experiment outputs used for analysis and visualization.

## Cell-DEVS Web Viewer
To visualize a run, load these two files together in the Cell-DEVS Web Viewer:
- `config/heat_diffusionVisualization_config.json`
- one of the scenario CSV files from `log/`

Examples:
- `heat_diffusionVisualization_config.json` with `heat_diffusion_base_scenario_log.csv`
- `heat_diffusionVisualization_config.json` with `heat_diffusion_hotter_source_log.csv`