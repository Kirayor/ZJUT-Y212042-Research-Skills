param(
    [int]$Port = 8088
)

$ErrorActionPreference = "Stop"

$ScriptDir = (Resolve-Path -LiteralPath $PSScriptRoot).Path
if ((Split-Path -Leaf $ScriptDir) -eq "scripts" -and (Test-Path -LiteralPath (Join-Path (Split-Path -Parent $ScriptDir) "SKILL.md"))) {
    $WorkspaceRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)
} else {
    $WorkspaceRoot = $ScriptDir
}

$Root = Join-Path $WorkspaceRoot "research_idea_demo"
if (-not (Test-Path -LiteralPath $Root)) {
    throw "Dashboard folder not found: $Root"
}

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    throw "Python was not found in PATH. Activate conda base or install Python, then rerun this script."
}

Write-Host "Serving dashboard from: $Root"
Write-Host "Open: http://127.0.0.1:$Port/research_idea_dashboard.html"
Write-Host "Press Ctrl+C to stop."

Push-Location $Root
try {
    & $python.Source -m http.server $Port --bind 127.0.0.1
}
finally {
    Pop-Location
}
