Heat Diffusion - Cadmium v2

Repository structure
--------------------
- atomics/
  Heat diffusion cell state, cell logic, and trigger generators.
- config/
  Scenario JSON files for baseline, hotter source, reduced cooling, and
  nonuniform initial condition.
- scripts/
  Windows launch scripts. `.bat` files are the simplest entry point and
  `run_heat_diffusion.ps1` is the shared runner underneath.
- top_model/
  Top-level Cadmium model and `main.cpp`.
- vendor/
  Vendored `nlohmann/json` headers used by Cadmium.
- bin/
  Prebuilt Windows executable and runtime DLLs after a successful build.
- simulation_results/
  Generated full CSV logs and `*_viewer.csv` files.

Run structure
-------------
- `scripts/run_baseline_heat_diffusion.bat`
- `scripts/run_hotter_source_heat_diffusion.bat`
- `scripts/run_reduced_cooling_heat_diffusion.bat`
- `scripts/run_nonuniform_initial_heat_diffusion.bat`

Each scenario launcher calls `scripts/run_heat_diffusion.ps1` and writes:
- `simulation_results/<scenario>_grid_log.csv`
- `simulation_results/<scenario>_grid_log_viewer.csv`

How to run with the existing bin/
---------------------------------
If `bin/heat_diffusion.exe` is present together with:
- `bin/libgcc_s_seh-1.dll`
- `bin/libstdc++-6.dll`
- `bin/libwinpthread-1.dll`

then no build step is needed. From the repository root in Windows:

`.\scripts\run_baseline_heat_diffusion.bat`

Repeat with the other `.bat` launchers as needed.

If you prefer, the underlying PowerShell script still works:

`powershell -ExecutionPolicy Bypass -File .\scripts\run_baseline_heat_diffusion.ps1`

How to rebuild after make clean
-------------------------------
If `bin/` was removed, install MSYS2 and the UCRT64 packages:

`pacman -S --needed mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-make`

Clone Cadmium beside this folder:

`git clone https://github.com/SimulationEverywhere/cadmium_v2 -b dev-rt`

Then build from the repository root:

`C:\msys64\ucrt64\bin\mingw32-make.exe clean`
`C:\msys64\ucrt64\bin\mingw32-make.exe all`

`all` rebuilds `bin/heat_diffusion.exe` and copies the required runtime DLLs
into `bin/`.

Outputs
-------
- Use the full `*_grid_log.csv` files for raw simulation results.
- Use the matching `*_viewer.csv` files with the Cell-DEVS Web Viewer:
  https://devssim.carleton.ca/cell-devs-viewer/
