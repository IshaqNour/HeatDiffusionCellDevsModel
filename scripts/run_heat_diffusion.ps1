param(
    [Parameter(Mandatory = $true)]
    [string]$ScenarioConfig,
    [double]$SimulationTime = 250.0,
    [string]$OutputCsv = ""
)

$repoRoot = Split-Path -Parent $PSScriptRoot

if (-not $OutputCsv) {
    $scenarioName = [System.IO.Path]::GetFileNameWithoutExtension($ScenarioConfig)
    $OutputCsv = Join-Path $repoRoot ("simulation_results/{0}_grid_log.csv" -f $scenarioName)
}

New-Item -ItemType Directory -Force (Join-Path $repoRoot "simulation_results") | Out-Null

Push-Location $repoRoot
try {
    $simulatorPath = Join-Path $repoRoot "bin/heat_diffusion.exe"
    if (-not (Test-Path $simulatorPath)) {
        $simulatorPath = Join-Path $repoRoot "bin/heat_diffusion"
    }
    if (-not (Test-Path $simulatorPath)) {
        throw "Simulator not found in bin/. If bin was removed, install MSYS2 with the UCRT64 gcc and make packages, clone cadmium_v2 beside this folder, and run 'C:\msys64\ucrt64\bin\mingw32-make.exe all' from the repository root."
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

            $viewerLines = [string[]](@($sep, $header) + $filteredRows)
            [System.IO.File]::WriteAllLines($viewerCsv, $viewerLines)
        }
    }
}
finally {
    Pop-Location
}
