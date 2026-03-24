param(
    [string]$CadmiumDir = "",
    [double]$SimulationTime = 250.0,
    [string]$OutputCsv = ""
)

$repoRoot = Split-Path -Parent $PSScriptRoot
$scenario = Join-Path $repoRoot "config/heat_diffusion_hotter_source_viewer_config.json"

& (Join-Path $PSScriptRoot "run_heat_diffusion.ps1") `
    -ScenarioConfig $scenario `
    -CadmiumDir $CadmiumDir `
    -SimulationTime $SimulationTime `
    -OutputCsv $OutputCsv
