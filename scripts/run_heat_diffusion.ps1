param(
    [Parameter(Mandatory = $true)]
    [string]$ScenarioConfig,
    [string]$CadmiumDir = "",
    [double]$SimulationTime = 250.0,
    [string]$OutputCsv = ""
)

$repoRoot = Split-Path -Parent $PSScriptRoot
$toolchainPath = "C:\msys64\ucrt64\bin;C:\msys64\usr\bin"

if (-not $OutputCsv) {
    $scenarioName = [System.IO.Path]::GetFileNameWithoutExtension($ScenarioConfig)
    $OutputCsv = Join-Path $repoRoot ("simulation_results/{0}_grid_log.csv" -f $scenarioName)
}

if (-not (Get-Command make -ErrorAction SilentlyContinue)) {
    throw "make was not found. Run this script from a Cadmium-ready shell (Git Bash, MSYS2, or WSL with make installed)."
}

New-Item -ItemType Directory -Force (Join-Path $repoRoot "simulation_results") | Out-Null

Push-Location $repoRoot
try {
    $env:Path = "$toolchainPath;$env:Path"

    if ($CadmiumDir) {
        & make "CADMIUM_DIR=$CadmiumDir" simulator
    } else {
        & make simulator
    }

    $simulatorPath = Join-Path $repoRoot "bin/heat_diffusion"
    if (-not (Test-Path $simulatorPath)) {
        $simulatorPath = Join-Path $repoRoot "bin/heat_diffusion.exe"
    }

    & $simulatorPath $ScenarioConfig $SimulationTime $OutputCsv
    if ($LASTEXITCODE -ne 0) {
        throw "Simulation executable failed with exit code $LASTEXITCODE."
    }

    if (Test-Path $OutputCsv) {
        $viewerCsv = Join-Path `
            ([System.IO.Path]::GetDirectoryName($OutputCsv)) `
            (([System.IO.Path]::GetFileNameWithoutExtension($OutputCsv)) + "_viewer.csv")

        $lines = Get-Content $OutputCsv
        if ($lines.Count -gt 2) {
            $sep = $lines[0]
            $header = $lines[1]
            $filteredRows = $lines |
                Select-Object -Skip 2 |
                Where-Object {
                    $columns = $_ -split ';', 5
                    $columns.Length -ge 5 -and $columns[2] -match '^\(\d+,\d+\)$'
                }

            @($sep, $header) + $filteredRows | Set-Content $viewerCsv
        }
    }
}
finally {
    Pop-Location
}
