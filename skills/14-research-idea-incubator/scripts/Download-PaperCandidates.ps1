param(
    [string]$CandidatesPath = "research_idea_agent\outputs\paper_candidates.md",
    [string]$OutputDir = "research_idea_agent\papers",
    [int]$MaxPapers = 5,
    [switch]$DryRun,
    [switch]$Overwrite
)

$ErrorActionPreference = "Stop"

$ScriptDir = (Resolve-Path -LiteralPath $PSScriptRoot).Path
if ((Split-Path -Leaf $ScriptDir) -eq "scripts" -and (Test-Path -LiteralPath (Join-Path (Split-Path -Parent $ScriptDir) "SKILL.md"))) {
    $ProjectDir = Split-Path -Parent (Split-Path -Parent $ScriptDir)
} else {
    $ProjectDir = $ScriptDir
}
Set-Location -LiteralPath $ProjectDir

if (-not [System.IO.Path]::IsPathRooted($CandidatesPath)) {
    $CandidatesPath = Join-Path $ProjectDir $CandidatesPath
}
if (-not [System.IO.Path]::IsPathRooted($OutputDir)) {
    $OutputDir = Join-Path $ProjectDir $OutputDir
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

function ConvertTo-SafeFileName {
    param(
        [string]$Text,
        [int]$MaxLength = 72
    )

    $safe = $Text.ToLowerInvariant()
    $safe = $safe -replace '[^\p{L}\p{Nd}]+', '_'
    $safe = $safe.Trim('_')
    if ([string]::IsNullOrWhiteSpace($safe)) {
        $safe = "paper"
    }
    if ($safe.Length -gt $MaxLength) {
        $safe = $safe.Substring(0, $MaxLength).Trim('_')
    }
    return $safe
}

function Split-MarkdownRow {
    param([string]$Line)

    $trimmed = $Line.Trim()
    if ($trimmed.StartsWith("|")) {
        $trimmed = $trimmed.Substring(1)
    }
    if ($trimmed.EndsWith("|")) {
        $trimmed = $trimmed.Substring(0, $trimmed.Length - 1)
    }

    return $trimmed -split '\|' | ForEach-Object { $_.Trim() }
}

function Normalize-PdfUrl {
    param([string]$Url)

    if ([string]::IsNullOrWhiteSpace($Url)) {
        return ""
    }

    $clean = $Url.Trim()
    if ($clean -match '^(not available|null|none|n/a)' -or $clean -match 'not available') {
        return ""
    }

    if ($clean -match '^https?://arxiv\.org/abs/(.+)$') {
        return "https://arxiv.org/pdf/$($Matches[1])"
    }

    if ($clean -match '^http://arxiv\.org/abs/(.+)$') {
        return "https://arxiv.org/pdf/$($Matches[1])"
    }

    if ($clean -notmatch '^https?://') {
        return ""
    }

    return $clean
}

function Get-CandidatesFromMarkdown {
    param([string]$Path)

    $rows = New-Object System.Collections.Generic.List[object]
    $lines = Get-Content -Encoding UTF8 -LiteralPath $Path
    $header = $null

    foreach ($line in $lines) {
        if ($line -notmatch '^\s*\|') {
            continue
        }
        if ($line -match '^\s*\|\s*-') {
            continue
        }

        $cells = @(Split-MarkdownRow -Line $line)
        if ($null -eq $header) {
            $header = $cells
            continue
        }

        $record = [ordered]@{}
        for ($i = 0; $i -lt $header.Count -and $i -lt $cells.Count; $i++) {
            $key = ($header[$i] -replace '\s+', '').ToLowerInvariant()
            $record[$key] = $cells[$i]
        }

        $title = $record["title"]
        $pdfUrl = $record["pdfurl"]
        if ([string]::IsNullOrWhiteSpace($pdfUrl)) {
            $pdfUrl = $record["url"]
        }

        $normalized = Normalize-PdfUrl -Url $pdfUrl
        if (-not [string]::IsNullOrWhiteSpace($title) -and -not [string]::IsNullOrWhiteSpace($normalized)) {
            $rows.Add([pscustomobject]@{
                title = $title
                year = $record["year"]
                source = $record["source/venue"]
                pdfUrl = $normalized
                verification = $record["verification"]
            })
        }
    }

    return $rows
}

function Get-CandidatesFromJson {
    param([string]$Path)

    $data = Get-Content -Raw -Encoding UTF8 -LiteralPath $Path | ConvertFrom-Json
    $rows = New-Object System.Collections.Generic.List[object]

    foreach ($item in @($data.candidates)) {
        $pdfUrl = $item.pdfUrl
        if ([string]::IsNullOrWhiteSpace($pdfUrl)) {
            $pdfUrl = $item.pdf_url
        }
        if ([string]::IsNullOrWhiteSpace($pdfUrl)) {
            $pdfUrl = $item.best_oa_location.pdf_url
        }
        if ([string]::IsNullOrWhiteSpace($pdfUrl) -and $item.url -match '^https?://arxiv\.org/abs/') {
            $pdfUrl = $item.url
        }

        $normalized = Normalize-PdfUrl -Url $pdfUrl
        if (-not [string]::IsNullOrWhiteSpace($item.title) -and -not [string]::IsNullOrWhiteSpace($normalized)) {
            $rows.Add([pscustomobject]@{
                title = $item.title
                year = $item.year
                source = $item.source
                pdfUrl = $normalized
                verification = $item.verification
            })
        }
    }

    return $rows
}

function Save-Pdf {
    param(
        [string]$Url,
        [string]$Path
    )

    $temp = "$Path.download"
    if (Test-Path -LiteralPath $temp) {
        Remove-Item -LiteralPath $temp -Force
    }

    Invoke-WebRequest -Uri $Url -OutFile $temp -TimeoutSec 90 -Headers @{
        "User-Agent" = "OpenClawResearchIdeaIncubator/0.1"
    }

    $bytes = [System.IO.File]::ReadAllBytes($temp)
    if ($bytes.Length -lt 5) {
        Remove-Item -LiteralPath $temp -Force
        throw "Downloaded file is too small."
    }

    $magic = [System.Text.Encoding]::ASCII.GetString($bytes, 0, [Math]::Min(5, $bytes.Length))
    if (-not $magic.StartsWith("%PDF")) {
        Remove-Item -LiteralPath $temp -Force
        throw "Downloaded file does not look like a PDF."
    }

    Move-Item -LiteralPath $temp -Destination $Path -Force
}

if (-not (Test-Path -LiteralPath $CandidatesPath)) {
    throw "Candidate file not found: $CandidatesPath"
}

$extension = [System.IO.Path]::GetExtension($CandidatesPath).ToLowerInvariant()
if ($extension -eq ".json") {
    $candidates = @(Get-CandidatesFromJson -Path $CandidatesPath)
} else {
    $candidates = @(Get-CandidatesFromMarkdown -Path $CandidatesPath)
}

$selected = $candidates | Select-Object -First $MaxPapers
$results = New-Object System.Collections.Generic.List[object]
$index = 1

foreach ($paper in $selected) {
    $safeTitle = ConvertTo-SafeFileName -Text $paper.title
    $fileName = "{0:D2}_{1}.pdf" -f $index, $safeTitle
    $target = Join-Path $OutputDir $fileName

    if ((Test-Path -LiteralPath $target) -and -not $Overwrite) {
        $results.Add([pscustomobject]@{
            status = "skipped_existing"
            title = $paper.title
            pdfUrl = $paper.pdfUrl
            file = $target
        })
        $index++
        continue
    }

    if ($DryRun) {
        $results.Add([pscustomobject]@{
            status = "dry_run"
            title = $paper.title
            pdfUrl = $paper.pdfUrl
            file = $target
        })
        $index++
        continue
    }

    try {
        Save-Pdf -Url $paper.pdfUrl -Path $target
        $results.Add([pscustomobject]@{
            status = "downloaded"
            title = $paper.title
            pdfUrl = $paper.pdfUrl
            file = $target
        })
    } catch {
        $results.Add([pscustomobject]@{
            status = "failed"
            title = $paper.title
            pdfUrl = $paper.pdfUrl
            file = $target
            error = $_.Exception.Message
        })
    }

    $index++
}

$runLogPath = Join-Path $OutputDir "downloaded_papers.json"
$summary = [ordered]@{
    generatedAt = (Get-Date).ToString("s")
    candidatesPath = $CandidatesPath
    outputDir = $OutputDir
    maxPapers = $MaxPapers
    dryRun = [bool]$DryRun
    results = $results
}

$summary | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 -LiteralPath $runLogPath

$downloaded = @($results | Where-Object { $_.status -eq "downloaded" }).Count
$failed = @($results | Where-Object { $_.status -eq "failed" }).Count

Write-Host "Candidate PDFs:" $candidates.Count
Write-Host "Selected:" $selected.Count
Write-Host "Downloaded:" $downloaded
Write-Host "Failed:" $failed
Write-Host "Log:" $runLogPath

foreach ($result in $results) {
    Write-Host ("[{0}] {1}" -f $result.status, $result.title)
}
