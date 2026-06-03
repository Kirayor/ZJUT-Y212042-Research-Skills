param(
    [Parameter(Mandatory = $true)]
    [string]$Idea,

    [string]$RunName = "",

    [switch]$CopyCurrentOutputs,

    [switch]$SetAsCurrent
)

$ErrorActionPreference = "Stop"

$ScriptDir = (Resolve-Path -LiteralPath $PSScriptRoot).Path
if ((Split-Path -Leaf $ScriptDir) -eq "scripts" -and (Test-Path -LiteralPath (Join-Path (Split-Path -Parent $ScriptDir) "SKILL.md"))) {
    $ProjectDir = Split-Path -Parent (Split-Path -Parent $ScriptDir)
} else {
    $ProjectDir = $ScriptDir
}
$OutputsDir = Join-Path $ProjectDir "research_idea_agent\outputs"

New-Item -ItemType Directory -Force -Path $OutputsDir | Out-Null

function ConvertTo-SafeSlug {
    param([string]$Text)

    $normalized = $Text.ToLowerInvariant()
    $normalized = $normalized -replace '[^\p{L}\p{Nd}]+', '-'
    $normalized = $normalized.Trim('-')

    if ([string]::IsNullOrWhiteSpace($normalized)) {
        return "idea"
    }

    if ($normalized.Length -gt 48) {
        $normalized = $normalized.Substring(0, 48).Trim('-')
    }

    return $normalized
}

function Get-IdeaSummary {
    param([string]$Text)

    $clean = ($Text -replace '\s+', ' ').Trim()
    if ($clean.Length -le 90) {
        return $clean
    }

    return ($clean.Substring(0, 90).Trim() + "...")
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
if ([string]::IsNullOrWhiteSpace($RunName)) {
    $RunName = "$(ConvertTo-SafeSlug -Text $Idea)-$timestamp"
} else {
    $RunName = "$(ConvertTo-SafeSlug -Text $RunName)-$timestamp"
}

$RunDir = Join-Path $OutputsDir $RunName
$RunPapersDir = Join-Path $RunDir "papers"
$RunArtifactsDir = Join-Path $RunDir "artifacts"

New-Item -ItemType Directory -Force -Path $RunDir | Out-Null
New-Item -ItemType Directory -Force -Path $RunPapersDir | Out-Null
New-Item -ItemType Directory -Force -Path $RunArtifactsDir | Out-Null

$summary = Get-IdeaSummary -Text $Idea
$createdAt = (Get-Date).ToString("s")

$readme = @"
# Idea Run

Created at: $createdAt

## Raw Idea

$Idea

## Short Summary

$summary

## Suggested Workflow

1. Run Stage 1-3 to generate idea card, keywords, and paper candidates.
2. Download selected PDFs into this run's papers/ folder or the shared research_idea_agent/papers/ folder.
3. Run native PDF summaries.
4. Generate literature matrix and research question.
5. Copy final artifacts into this folder for submission or comparison.

## Main Artifacts

- input_idea.txt
- run_meta.json
- artifacts/
- papers/
"@

Set-Content -Encoding UTF8 -LiteralPath (Join-Path $RunDir "README.md") -Value $readme
Set-Content -Encoding UTF8 -LiteralPath (Join-Path $RunDir "input_idea.txt") -Value $Idea

$meta = [ordered]@{
    createdAt = $createdAt
    runName = $RunName
    runDir = $RunDir
    idea = $Idea
    summary = $summary
    papersDir = $RunPapersDir
    artifactsDir = $RunArtifactsDir
}

$meta | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $RunDir "run_meta.json")

if ($CopyCurrentOutputs) {
    $filesToCopy = @(
        "idea_card.md",
        "keywords.md",
        "paper_candidates.md",
        "paper_candidates.json",
        "selected_papers.md",
        "paper_summaries.md",
        "literature_matrix.md",
        "research_question.md"
    )

    foreach ($file in $filesToCopy) {
        $source = Join-Path $OutputsDir $file
        if (Test-Path -LiteralPath $source) {
            Copy-Item -LiteralPath $source -Destination (Join-Path $RunArtifactsDir $file) -Force
        }
    }

    $processData = Join-Path $ProjectDir "research_idea_demo\process_data.json"
    if (Test-Path -LiteralPath $processData) {
        Copy-Item -LiteralPath $processData -Destination (Join-Path $RunArtifactsDir "process_data.json") -Force
    }
}

if ($SetAsCurrent) {
    $current = [ordered]@{
        runName = $RunName
        runDir = $RunDir
        idea = $Idea
        createdAt = $createdAt
    }
    $current | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $OutputsDir "current_run.json")
}

Write-Host "Created idea output folder:"
Write-Host $RunDir
Write-Host ""
Write-Host "Summary:"
Write-Host $summary
