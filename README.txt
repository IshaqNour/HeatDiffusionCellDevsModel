Heat Diffusion - Cadmium v2 implementation from the formal specification

This folder now follows the formal model written in
HeatDiffusion_CellDEVS_Assignment2_Report_Final.docx instead of the earlier
simplified version. The repository implements:

  - HeatDiffusionTop as the top coupled model
  - HeatSurfaceCoupled as the wrapped 10 x 10 Cell-DEVS surface
  - HeatGenerator and ColdGenerator as DEVS atomic trigger generators
  - HeatDiffusionCell as the Cell-DEVS atomic cell

Reference mapping used while building this implementation
---------------------------------------------------------
- Legacy heat diffusion model:
  Moore-neighborhood averaging, wrapped border, default temperature 24,
  hot points at (2,2) and (5,5), cold points at (2,8) and (8,8).
- Life game / lecture format:
  Cell-DEVS state + cell class, JSON scenario file, Cadmium simulator main, CSV
  logger output for the Cell-DEVS viewer.
- Professor viewer requirements:
  every scenario here uses origin [0,0] and includes a viewer section with
  field/breaks/colors.
- Your formal report:
  explicit trigger ports inputHeat/inputCold, DEVS generators with exponential
  mean 50 s, hot/cold trigger precedence over diffusion, and transport delay of
  1 second.

Behavior implemented from the report
------------------------------------
- Initial temperature is 24.0 for every cell, including the four source-linked
  cells.
- Every regular update computes the average of the wrapped Moore neighborhood of
  range 1, including the cell itself.
- A heat trigger on (2,2) or (5,5) samples a new temperature from Uniform[24,40].
- A cold trigger on (2,8) or (8,8) samples a new temperature from Uniform[-10,15].
- Trigger arrivals take precedence over the diffusion rule on the designated
  source cells.
- The DEVS generators emit trigger tokens with exponential inter-arrival times
  of mean 50 seconds.

Repository structure
--------------------
- atomics/   HeatDiffusionState + HeatDiffusionCell + trigger generators
- config/    Viewer-ready experimental scenarios
- top_model/ Cell-DEVS surface + top coupled model + main simulator entry point
- scripts/   PowerShell helpers for common runs
- makefile   Build target for the simulator

Scenario files
--------------
- heat_diffusion_baseline_viewer_config.json
  Baseline case: matches the formal specification.
- heat_diffusion_hotter_source_viewer_config.json
  Same model, stronger hot-source input range.
- heat_diffusion_reduced_cooling_viewer_config.json
  Same model, but only one active cold source.
- heat_diffusion_nonuniform_initial_viewer_config.json
  Same model, but starts from a non-uniform initial temperature field.

Experimental frame
------------------
The experimental frame follows the recommended "Option A" approach:
- the C++ Cadmium model is frozen
- only the JSON case files change between runs
- one script is provided per experiment
- each run produces its own full log and viewer-ready filtered log

See scripts/README.txt for the detailed explanation of each run.

Build requirements
------------------
- g++
- make
- cadmium_v2 available either in vendor/cadmium_v2 or beside this folder
- DESTimes if your local Cadmium layout still uses it

The JSON dependency required by Cadmium is already vendored in this repository
under vendor/nlohmann, so no separate nlohmann-json installation is required.

Build command
-------------
make simulator

Manual run command
------------------
./bin/heat_diffusion config/heat_diffusion_baseline_viewer_config.json 250 simulation_results/heat_diffusion_baseline_grid_log.csv

If using Windows PowerShell, the equivalent direct command is:
.\bin\heat_diffusion.exe .\config\heat_diffusion_baseline_viewer_config.json 250 .\simulation_results\heat_diffusion_baseline_grid_log.csv

On Windows, the preferred path is to use one of the PowerShell helper scripts
below because they add the MSYS2 toolchain directories to PATH before running
the simulator.

PowerShell helper scripts
-------------------------
- scripts/run_baseline_heat_diffusion.ps1
- scripts/run_hotter_source_heat_diffusion.ps1
- scripts/run_reduced_cooling_heat_diffusion.ps1
- scripts/run_nonuniform_initial_heat_diffusion.ps1

Each script builds the simulator (if needed) and writes a meaningfully named CSV
file into simulation_results/.

Important run-time note
-----------------------
Do not judge the baseline behavior from a very short debug run. The generator
seeds are fixed, and for the baseline configuration the first sampled cold and
heat trigger times are approximately 95.22 s and 112.44 s. A 10 s run therefore
legitimately produces only initialization rows at time 0.

Clean-clone workflow expected by the instructor
-----------------------------------------------
1. Clone this repository.
2. In the parent folder of this repository, clone Cadmium exactly as:
   git clone https://github.com/SimulationEverywhere/cadmium_v2 -b dev-rt
3. Move into this repository folder.
4. Run:
   make simulator
5. Run either:
   ./bin/heat_diffusion config/heat_diffusion_baseline_viewer_config.json 250 simulation_results/heat_diffusion_baseline_grid_log.csv
   or, in PowerShell:
   .\bin\heat_diffusion.exe .\config\heat_diffusion_baseline_viewer_config.json 250 .\simulation_results\heat_diffusion_baseline_grid_log.csv
   or one of the PowerShell experiment scripts.

Because the formal top model also logs the DEVS generators, the generic runner
additionally creates a second "*_viewer.csv" file that keeps only the Cell-DEVS
grid rows for the web viewer.

Viewer workflow
---------------
1. Run one of the scenario scripts so both a full CSV and a matching
   "*_viewer.csv" file are created in simulation_results/.
2. Open https://devssim.carleton.ca/cell-devs-viewer/
3. In the viewer, load the same JSON scenario file used for the run.
4. Load the matching "*_viewer.csv" file for that scenario.
5. Press play and move through the time controls to inspect the evolution of the
   temperature field.
6. Capture screenshots at a few meaningful times for the report.
7. Record one short video for the most interesting run if your assignment
   submission requires it.

Compatibility note
------------------
The course material alternates between "model" and "cell_type" in JSON
examples. The provided config files include both names for compatibility across
course examples.

The reference scenario also uses JSON EIC definitions so HeatSurfaceCoupled
matches the formal specification:
  inputHeat -> HeatCell(2,2), HeatCell(5,5)
  inputCold -> HeatCell(2,8), HeatCell(8,8)

Verification note
-----------------
The repository was verified in this workspace after:
- cloning cadmium_v2 beside the project using the dev-rt branch
- building with make simulator
- running the baseline experiment successfully

The baseline run generated:
- simulation_results/heat_diffusion_baseline_viewer_config_grid_log.csv
- simulation_results/heat_diffusion_baseline_viewer_config_grid_log_viewer.csv
