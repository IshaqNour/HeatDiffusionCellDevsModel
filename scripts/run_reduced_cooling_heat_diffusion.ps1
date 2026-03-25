param(
    [double]$SimulationTime = 250.0,
    [string]$OutputCsv = ""
)

$repoRoot = Split-Path -Parent $PSScriptRoot
$scenario = Join-Path $repoRoot "config/heat_diffusion_reduced_cooling_viewer_config.json"

& (Join-Path $PSScriptRoot "run_heat_diffusion.ps1") `
    -ScenarioConfig $scenario `
    -SimulationTime $SimulationTime `
    -OutputCsv $OutputCsv
