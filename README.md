# Heat Diffusion Cell-DEVS Model

This repository contains a Cadmium Cell-DEVS heat diffusion simulation with
four predefined scenarios:
- baseline
- hotter source
- reduced cooling
- nonuniform initial condition

The build and run flow follows the same root-level shell-script structure as
`CellDevsInformationImpact`:
- `build_sim.sh` builds the simulator
- `run_*_scenario.sh` builds and runs a single predefined scenario
- generated CSV logs are written to `log/`

This repository does not use the older custom root `makefile` / `make all`
workflow. The supported build path is the shell-script + CMake flow documented
below.

## Repository Structure

- `atomics/` and `include/`: Cell-DEVS state, cell logic, and trigger generators
- `main/` and `top_model/`: simulation entry point and coupled model definitions
- `config/`: scenario JSON files and the web viewer JSON
- `log/`: generated scenario CSV logs
- `Simulation_videos/`: optional saved viewer recordings
- `build_sim.sh`: build helper
- `run_base_scenario.sh`: baseline experiment
- `run_hotter_source_scenario.sh`: hotter source experiment
- `run_reduced_cooling_scenario.sh`: reduced cooling experiment
- `run_nonuniform_initial_scenario.sh`: nonuniform initial experiment
- `bin/` and `build/`: generated during compilation

## WSL Workflow

This is the recommended Windows workflow.

Install the required packages once in Ubuntu/WSL:

```bash
sudo apt update
sudo apt install -y build-essential cmake git
```

If you are cloning from scratch inside WSL:

```bash
git clone https://github.com/SimulationEverywhere/cadmium_v2 -b dev-rt
git clone <your-heat-diffusion-repo-url>
cd HeatDiffusionCellDevsModel
bash build_sim.sh
```

If the repositories are already on your Windows drive, open WSL and enter the
repo through `/mnt/c/...`:

```bash
cd /mnt/c/Users/nou99678/Documents/A2/HeatDiffusionCellDevsModel
bash build_sim.sh
```

If `cadmium_v2` is cloned beside this repository, `bash build_sim.sh` works
without any extra setup. If Cadmium is somewhere else, set it manually:

```bash
export CADMIUM=/path/to/cadmium_v2/include
```

Run the scenario scripts one by one:

```bash
cd /mnt/c/Users/nou99678/Documents/A2/HeatDiffusionCellDevsModel

bash run_base_scenario.sh
cat log/heat_diffusion_base_scenario_log.csv

bash run_hotter_source_scenario.sh
cat log/heat_diffusion_hotter_source_log.csv

bash run_reduced_cooling_scenario.sh
cat log/heat_diffusion_reduced_cooling_log.csv

bash run_nonuniform_initial_scenario.sh
cat log/heat_diffusion_nonuniform_initial_log.csv
```

What each script generates:
- `run_base_scenario.sh` -> `log/heat_diffusion_base_scenario_log.csv`
- `run_hotter_source_scenario.sh` -> `log/heat_diffusion_hotter_source_log.csv`
- `run_reduced_cooling_scenario.sh` -> `log/heat_diffusion_reduced_cooling_log.csv`
- `run_nonuniform_initial_scenario.sh` -> `log/heat_diffusion_nonuniform_initial_log.csv`

Note:
- each run script calls `build_sim.sh` before executing the scenario
- you can run `bash build_sim.sh` separately first if you only want to rebuild once

## Bash Workflow

Use this section if you are already in Linux or in a bash environment where
`cmake`, `make`, and `g++` are available on `PATH`.

Clone and build:

```bash
git clone https://github.com/SimulationEverywhere/cadmium_v2 -b dev-rt
git clone <your-heat-diffusion-repo-url>
cd HeatDiffusionCellDevsModel
bash build_sim.sh
```

Run the predefined scenarios:

```bash
bash run_base_scenario.sh
bash run_hotter_source_scenario.sh
bash run_reduced_cooling_scenario.sh
bash run_nonuniform_initial_scenario.sh
```

Check outputs:

```bash
cat log/heat_diffusion_base_scenario_log.csv
cat log/heat_diffusion_hotter_source_log.csv
cat log/heat_diffusion_reduced_cooling_log.csv
cat log/heat_diffusion_nonuniform_initial_log.csv
```

## Dependencies

You need:
- Cadmium v2 headers available through `$CADMIUM`, or a sibling `../cadmium_v2`
- `cmake`
- `make`
- a C++17-compatible compiler
- a Linux or Linux-like shell environment

You do not need an MSYS2-specific `C:\msys64` setup for the documented WSL
workflow.

## Scenario Files

Predefined simulation inputs:
- `config/heat_config_base_scenario.json`
- `config/heat_config_hotter_source.json`
- `config/heat_config_reduced_cooling.json`
- `config/heat_config_nonuniform_initial.json`

Viewer configuration:
- `config/heat_diffusionVisualization_config.json`
- `config/heat_diffusion_base_scenario_config.json`
- `config/heat_diffusion_hotter_source_config.json`
- `config/heat_diffusion_reduced_cooling_config.json`
- `config/heat_diffusion_nonuniform_initial_config.json`

## Output Logs

Generated outputs are written to `log/`:
- `heat_diffusion_base_scenario_log.csv`
- `heat_diffusion_hotter_source_log.csv`
- `heat_diffusion_reduced_cooling_log.csv`
- `heat_diffusion_nonuniform_initial_log.csv`

These files are the experiment outputs used for analysis and visualization.

## Cell-DEVS Web Viewer

To visualize a run in the Cell-DEVS Web Viewer, load:
- one matching `*_config.json` file from `config/`
- one matching CSV file from `log/`

Examples:
- `heat_diffusion_base_scenario_config.json` with `heat_diffusion_base_scenario_log.csv`
- `heat_diffusion_hotter_source_config.json` with `heat_diffusion_hotter_source_log.csv`
- `heat_diffusion_reduced_cooling_config.json` with `heat_diffusion_reduced_cooling_log.csv`
- `heat_diffusion_nonuniform_initial_config.json` with `heat_diffusion_nonuniform_initial_log.csv`