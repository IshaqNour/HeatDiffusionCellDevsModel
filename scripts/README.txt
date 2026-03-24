Heat Diffusion experimental-frame scripts

These scripts implement the Assignment 2 "experimental frame" using Option A:
the C++ model stays fixed, while each run changes only the JSON input case.

Scripts and intent
------------------
- run_baseline_heat_diffusion.ps1
  Runs the formal specification without changing any inputs.
  Files:
    config/heat_diffusion_baseline_viewer_config.json
  Expected use:
    reference run for comparison against all later experiments.

- run_hotter_source_heat_diffusion.ps1
  Keeps the same model and same source locations, but increases the hot-source
  sampling range from Uniform[24,40] to Uniform[30,45].
  Files:
    config/heat_diffusion_hotter_source_viewer_config.json
  Expected effect:
    stronger and faster local warming around the hot-source cells.

- run_reduced_cooling_heat_diffusion.ps1
  Keeps the same model and hot sources, but reduces cooling by leaving only one
  active cold source cell.
  Files:
    config/heat_diffusion_reduced_cooling_viewer_config.json
  Expected effect:
    the surface should remain warmer overall than in the baseline case.

- run_nonuniform_initial_heat_diffusion.ps1
  Keeps the same model and source behavior, but starts from a non-uniform
  initial temperature field.
  Files:
    config/heat_diffusion_nonuniform_initial_viewer_config.json
  Expected effect:
    the warm patch should diffuse over time before later generator events keep
    perturbing the field.

Shared runner
-------------
- run_heat_diffusion.ps1
  Common helper used by all experiment scripts.
  It:
    builds the simulator
    runs the selected JSON case
    writes a full CSV log
    writes a filtered "*_viewer.csv" log for the Cell-DEVS Web Viewer

Output naming
-------------
If no output filename is provided, each script creates:
- simulation_results/<scenario_name>_grid_log.csv
- simulation_results/<scenario_name>_grid_log_viewer.csv

Run all required experiments
----------------------------
From the repository root, run:
- powershell -ExecutionPolicy Bypass -File .\scripts\run_baseline_heat_diffusion.ps1
- powershell -ExecutionPolicy Bypass -File .\scripts\run_hotter_source_heat_diffusion.ps1
- powershell -ExecutionPolicy Bypass -File .\scripts\run_reduced_cooling_heat_diffusion.ps1
- powershell -ExecutionPolicy Bypass -File .\scripts\run_nonuniform_initial_heat_diffusion.ps1

Exact copy-paste workflow
-------------------------
Use Windows PowerShell from the project root. You do not need to manually start
an MSYS2 MinGW shell when using the PowerShell scripts below, because the shared
runner already adds the MSYS2 toolchain folders to PATH before building and
running the simulator.

1. Open Windows PowerShell.
2. Move into the project folder:
   cd "C:\Users\ishaq\OneDrive - Carleton University\SYSC4906G\Assignment2\Cadmium-HeatDiffusion"
3. Run the baseline experiment:
   powershell -ExecutionPolicy Bypass -File .\scripts\run_baseline_heat_diffusion.ps1
4. Run the hotter-source experiment:
   powershell -ExecutionPolicy Bypass -File .\scripts\run_hotter_source_heat_diffusion.ps1
5. Run the reduced-cooling experiment:
   powershell -ExecutionPolicy Bypass -File .\scripts\run_reduced_cooling_heat_diffusion.ps1
6. Run the nonuniform-initial-condition experiment:
   powershell -ExecutionPolicy Bypass -File .\scripts\run_nonuniform_initial_heat_diffusion.ps1
7. Open the results folder and confirm these files now exist:
   dir .\simulation_results\
8. You should see four full logs:
   heat_diffusion_baseline_viewer_config_grid_log.csv
   heat_diffusion_hotter_source_viewer_config_grid_log.csv
   heat_diffusion_reduced_cooling_viewer_config_grid_log.csv
   heat_diffusion_nonuniform_initial_viewer_config_grid_log.csv
9. You should also see four viewer logs:
   heat_diffusion_baseline_viewer_config_grid_log_viewer.csv
   heat_diffusion_hotter_source_viewer_config_grid_log_viewer.csv
   heat_diffusion_reduced_cooling_viewer_config_grid_log_viewer.csv
   heat_diffusion_nonuniform_initial_viewer_config_grid_log_viewer.csv
10. Quickly confirm the baseline full CSV contains times greater than 0:
    Get-Content .\simulation_results\heat_diffusion_baseline_viewer_config_grid_log.csv | Select-Object -Last 20

Cell-DEVS Web Viewer steps
--------------------------
Use the matching JSON file and matching "*_viewer.csv" file from the same
experiment. Do not upload the full CSV log to the viewer.

1. Open this page in your browser:
   https://devssim.carleton.ca/cell-devs-viewer/
2. For the baseline experiment, load:
   config\heat_diffusion_baseline_viewer_config.json
   simulation_results\heat_diffusion_baseline_viewer_config_grid_log_viewer.csv
3. Press play in the viewer.
4. Move through the simulation timeline and capture screenshots at:
   t = 0
   just after the first cold event, around t = 96
   just after the first heat event, around t = 113
   a later frame such as t = 250
5. Repeat the same process for the hotter-source experiment:
   config\heat_diffusion_hotter_source_viewer_config.json
   simulation_results\heat_diffusion_hotter_source_viewer_config_grid_log_viewer.csv
6. Repeat the same process for the reduced-cooling experiment:
   config\heat_diffusion_reduced_cooling_viewer_config.json
   simulation_results\heat_diffusion_reduced_cooling_viewer_config_grid_log_viewer.csv
7. Repeat the same process for the nonuniform-initial-condition experiment:
   config\heat_diffusion_nonuniform_initial_viewer_config.json
   simulation_results\heat_diffusion_nonuniform_initial_viewer_config_grid_log_viewer.csv
8. Save the screenshots for the report.
9. If required, record one short viewer video for the most interesting run.

If you prefer MSYS2
-------------------
You only need MSYS2 if you want to run the binary manually or use make directly
yourself. For this setup, use the MSYS2 UCRT64 shell, not the plain MINGW64
shell, because the configured toolchain path points to C:\msys64\ucrt64\bin.
For the assignment workflow, the recommended option is still Windows PowerShell
with the provided scripts.

Assignment-completion check
---------------------------
The "execute various simulation examples" requirement is satisfied when:
- all four scripts above have been run successfully
- simulation_results/ contains four full CSV logs
- simulation_results/ contains four matching "*_viewer.csv" files
- the full CSV files contain rows with time greater than 0
- the runs are compared in the report using the changed input conditions

For the baseline case, a very short run can legitimately show only time-0 rows
because the first fixed-seed generator events occur much later. Use the default
250 s run time unless you are deliberately doing a quick debug run.

Recommended report format
-------------------------
For each experiment, document:
- objective
- files used
- changed inputs
- expected behavior
- observed behavior from the CSV/Web Viewer
- interpretation
