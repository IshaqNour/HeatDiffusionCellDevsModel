Heat Diffusion scripts

Scripts
-------
- run_heat_diffusion.bat
  Windows wrapper for the shared runner.
- run_baseline_heat_diffusion.bat
- run_hotter_source_heat_diffusion.bat
- run_reduced_cooling_heat_diffusion.bat
- run_nonuniform_initial_heat_diffusion.bat
- run_heat_diffusion.ps1
  Shared runner. Uses the existing simulator in `bin/` and writes the full CSV
  log plus the matching `*_viewer.csv` file.
- run_baseline_heat_diffusion.ps1
- run_hotter_source_heat_diffusion.ps1
- run_reduced_cooling_heat_diffusion.ps1
- run_nonuniform_initial_heat_diffusion.ps1

Recommended Windows run commands
-------------------------------
From the repository root:

`.\scripts\run_baseline_heat_diffusion.bat`
`.\scripts\run_hotter_source_heat_diffusion.bat`
`.\scripts\run_reduced_cooling_heat_diffusion.bat`
`.\scripts\run_nonuniform_initial_heat_diffusion.bat`

The `.bat` files call the `.ps1` scripts with `-ExecutionPolicy Bypass`, so the
professor does not need to type the longer PowerShell command manually.

Output files
------------
Each run creates:
- `simulation_results/<scenario_name>_grid_log.csv`
- `simulation_results/<scenario_name>_grid_log_viewer.csv`

If bin/ is missing
------------------
Rebuild first using the instructions in the top-level `README.txt`, then run
the scripts again.
