param(
    [string]$WorkspaceRoot,
    [string]$OutputsDir,
    [string]$DemoDir,
    [string]$ProcessDataPath
)

$ErrorActionPreference = "Stop"

if (-not $WorkspaceRoot) {
    $SkillDir = Split-Path -Parent $PSScriptRoot
    $SkillsDir = Split-Path -Parent $SkillDir
    $WorkspaceRoot = Split-Path -Parent $SkillsDir
}
$WorkspaceRoot = (Resolve-Path -LiteralPath $WorkspaceRoot).Path

if (-not $OutputsDir) {
    $OutputsDir = Join-Path $WorkspaceRoot "research_idea_agent\outputs"
}
if (-not $DemoDir) {
    $DemoDir = Join-Path $WorkspaceRoot "research_idea_demo"
}
if (-not $ProcessDataPath) {
    $ProcessDataPath = Join-Path $DemoDir "process_data.json"
}

function Read-TextOrEmpty {
    param([string]$Path)
    if (Test-Path -LiteralPath $Path) {
        return Get-Content -Raw -Encoding UTF8 -LiteralPath $Path
    }
    return ""
}

function Clean-Md {
    param([string]$Text)
    if ($null -eq $Text) { return "" }
    $value = $Text.Trim()
    $value = $value -replace "^\s*[-*]\s+", ""
    $value = $value -replace "^\s*\d+\.\s+", ""
    $value = $value -replace "\*\*(.*?)\*\*", '$1'
    $value = $value -replace '`([^`]+)`', '$1'
    $value = $value -replace '\[(.*?)\]\((.*?)\)', '$1'
    $value = $value -replace '(?:;|\uFF1B)\s*$', ''
    $value = $value -replace '\s+', ' '
    return $value.Trim()
}

function U {
    param([string]$Text)
    return [regex]::Unescape($Text)
}

function Get-Section {
    param(
        [string]$Text,
        [string]$Heading,
        [int]$Level = 2
    )
    if (-not $Text) { return "" }
    $hashes = "#" * $Level
    $pattern = "(?ms)^$([regex]::Escape($hashes))\s+$([regex]::Escape($Heading))\s*\r?\n(?<body>.*?)(?=^#{1,$Level}\s+|\z)"
    $match = [regex]::Match($Text, $pattern)
    if ($match.Success) { return $match.Groups["body"].Value.Trim() }
    return ""
}

function Get-FirstParagraph {
    param([string]$Text)
    if (-not $Text) { return "" }
    $paragraphs = @([regex]::Split($Text.Trim(), "(\r?\n){2,}") |
        Where-Object { $_.Trim() -and $_.Trim() -notmatch "^#" }
    )
    if (-not $paragraphs) { return "" }
    return Clean-Md $paragraphs[0]
}

function Get-Bullets {
    param(
        [string]$Text,
        [int]$Limit = 12
    )
    if (-not $Text) { return @() }
    $items = New-Object System.Collections.Generic.List[string]
    foreach ($line in ($Text -split "\r?\n")) {
        if ($line -match "^\s*(?:[-*]|\d+\.)\s+(.+?)\s*$") {
            $item = Clean-Md $Matches[1]
            if ($item) { $items.Add($item) }
        }
        if ($items.Count -ge $Limit) { break }
    }
    return @($items)
}

function Get-NumberedSummaries {
    param(
        [string]$Text,
        [int]$Limit = 5
    )
    $summaries = New-Object System.Collections.Generic.List[string]
    if (-not $Text) { return @() }

    $currentTitle = ""
    $currentBody = New-Object System.Collections.Generic.List[string]

    function Flush-NumberedSummary {
        param(
            [string]$Title,
            [System.Collections.Generic.List[string]]$Body,
            [System.Collections.Generic.List[string]]$Out
        )
        if (-not $Title) { return }
        $cleanTitle = (Clean-Md $Title) -replace '[\s\p{P}]+$', ''
        $bodyParts = @($Body.ToArray()) | Where-Object { $_ }
        if ($bodyParts.Count -gt 0) {
            $Out.Add(("{0}: {1}" -f $cleanTitle, ($bodyParts -join "; ")))
        } else {
            $Out.Add($cleanTitle)
        }
    }

    foreach ($line in ($Text -split "\r?\n")) {
        if ($line -match "^\s*#{1,6}\s+") {
            break
        }

        if ($line -match "^\s*\d+\.\s+(.+?)\s*$") {
            Flush-NumberedSummary $currentTitle $currentBody $summaries
            if ($summaries.Count -ge $Limit) { break }
            $currentTitle = $Matches[1]
            $currentBody = New-Object System.Collections.Generic.List[string]
            continue
        }

        if (-not $currentTitle) { continue }

        if ($line -match "^\s*[-*]\s+(.+?)\s*$") {
            $item = Clean-Md $Matches[1]
            if ($item) { $currentBody.Add($item) }
            continue
        }

        $textLine = Clean-Md $line
        if ($textLine) { $currentBody.Add($textLine) }
    }

    if ($summaries.Count -lt $Limit) {
        Flush-NumberedSummary $currentTitle $currentBody $summaries
    }

    return @($summaries.ToArray() | Select-Object -First $Limit)
}

function Get-QuotedOrFirstQuestion {
    param([string]$Text)
    if (-not $Text) { return "" }
    foreach ($line in ($Text -split "\r?\n")) {
        if ($line -match "^\s*>\s*(.+)") {
            return Clean-Md $Matches[1]
        }
    }
    foreach ($line in ($Text -split "\r?\n")) {
        if ($line -match "\?") {
            return Clean-Md $line
        }
    }
    return Get-FirstParagraph $Text
}

function Convert-MatrixRows {
    param([string]$Text)
    $rows = New-Object System.Collections.Generic.List[object]
    if (-not $Text) { return @() }

    $headerSkipped = $false
    foreach ($line in ($Text -split "\r?\n")) {
        $trimmed = $line.Trim()
        if (-not $trimmed.StartsWith("|")) { continue }
        if ($trimmed -match "^\|\s*-+\s*\|") { continue }
        if (-not $headerSkipped) {
            $headerSkipped = $true
            continue
        }

        $cells = @($trimmed.Trim("|") -split "\|") | ForEach-Object { Clean-Md $_ }
        if ($cells.Count -lt 8) { continue }

        $rows.Add([ordered]@{
            title = $cells[0]
            task = $cells[1]
            method = $cells[2]
            contribution = if ($cells.Count -ge 7) { $cells[6] } else { "" }
            limitation = if ($cells.Count -ge 8) { $cells[7] } else { "" }
            relation = if ($cells.Count -ge 9) { $cells[8] } else { $cells[-1] }
        })
    }
    return @($rows.ToArray())
}

function New-Risk {
    param(
        [string]$Name,
        [string]$Level,
        [string]$Description,
        [string]$Response
    )
    return [ordered]@{
        name = $Name
        level = $Level
        description = $Description
        response = $Response
    }
}

$ideaCard = Read-TextOrEmpty (Join-Path $OutputsDir "idea_card.md")
$keywordsMd = Read-TextOrEmpty (Join-Path $OutputsDir "keywords.md")
$matrixMd = Read-TextOrEmpty (Join-Path $OutputsDir "literature_matrix.md")
$rqMd = Read-TextOrEmpty (Join-Path $OutputsDir "research_question.md")

$rawIdea = Get-FirstParagraph (Get-Section $ideaCard "Raw Idea")
$refinedIdea = Get-FirstParagraph (Get-Section $ideaCard "Refined Problem")
$assumption = Get-FirstParagraph (Get-Section $ideaCard "Core Assumption")
$questions = Get-Bullets (Get-Section $ideaCard "Next Questions") 8

$keywordGroups = [ordered]@{}
$keywordMap = [ordered]@{
    core = "Core Terms"
    method = "Method Terms"
    domain = "Domain Terms"
    dataset = "Dataset Terms"
    evaluation = "Evaluation Terms"
    chinese = "Chinese Keywords"
}
foreach ($entry in $keywordMap.GetEnumerator()) {
    $terms = Get-Bullets (Get-Section $keywordsMd $entry.Value) 16
    if ($terms.Count -gt 0) {
        $keywordGroups[$entry.Key] = $terms
    }
}

$papers = Convert-MatrixRows $matrixMd

$recommended = Get-Section $rqMd "Recommended Research Question"
$finalDraft = Get-QuotedOrFirstQuestion $recommended
if (-not $finalDraft) {
    $finalDraft = Get-QuotedOrFirstQuestion (Get-Section $rqMd "Candidate Research Questions")
}

$whyMatters = Get-Section $rqMd "Why This Question Matters"
$claimItems = Get-NumberedSummaries $whyMatters 4
$claim = if ($claimItems.Count -gt 0) {
    $claimItems -join (U '\uff1b')
} else {
    Get-FirstParagraph $whyMatters
}
if (-not $claim) {
    $claim = U '\u8be5\u95ee\u9898\u5c06\u6269\u6563\u6a21\u578b\u81ea\u7136\u56fe\u50cf\u7f16\u8f91\u3001image-only VLM \u9c81\u68d2\u6027\u6d4b\u8bd5\u548c\u4f4e\u98ce\u9669 captioning/VQA \u8bc4\u4f30\u7ed3\u5408\u8d77\u6765\uff0c\u7528\u6587\u732e\u8bc1\u636e\u628a\u5bbd\u6cdb idea \u6536\u655b\u4e3a\u53ef\u6267\u884c\u7814\u7a76\u95ee\u9898\u3002'
}

$minimalPlan = Get-NumberedSummaries (Get-Section $rqMd "Minimal Experiment Plan") 5
$nextExperiment = if ($minimalPlan.Count -gt 0) {
    (U '\u6700\u5c0f\u5b9e\u9a8c\u8ba1\u5212\uff1a') + ($minimalPlan -join (U '\uff1b'))
} else {
    U '\u9009\u62e9\u5c11\u91cf\u81ea\u7136\u56fe\u50cf\uff0c\u751f\u6210\u6269\u6563\u7f16\u8f91\u53d8\u4f53\uff0c\u5bf9\u6bd4\u539f\u56fe\u548c\u7f16\u8f91\u56fe\u5728 VLM captioning/VQA \u8f93\u51fa\u4e0a\u7684\u53d8\u5316\u3002'
}

$risks = New-Object System.Collections.Generic.List[object]
$noveltyRisks = Get-Bullets (Get-Section $rqMd "Novelty Risk") 3
$experimentRisks = Get-Bullets (Get-Section $rqMd "Experiment Risk") 3
$reviewerConcerns = Get-Bullets (Get-Section $rqMd "Reviewer Concerns") 3

if ($noveltyRisks.Count -gt 0) {
    $risks.Add((New-Risk (U '\u521b\u65b0\u6027\u98ce\u9669') "high" $noveltyRisks[0] (U '\u4f18\u5148\u5168\u6587\u6838\u67e5\u6700\u63a5\u8fd1\u7684 diffusion + VLM adversarial \u5de5\u4f5c\uff0c\u5e76\u5728\u62a5\u544a\u4e2d\u660e\u786e\u672c\u9879\u76ee\u7684\u4f4e\u98ce\u9669\u4efb\u52a1\u8fb9\u754c\u3002')))
}
if ($experimentRisks.Count -gt 0) {
    $risks.Add((New-Risk (U '\u5b9e\u9a8c\u98ce\u9669') "medium" $experimentRisks[0] (U '\u628a\u5b9e\u9a8c\u6536\u7a84\u5230 20-50 \u5f20\u56fe\u50cf\u548c\u4e00\u4e2a VLM\uff0c\u5148\u8bc1\u660e\u6d41\u7a0b\u53ef\u884c\uff0c\u518d\u8ba8\u8bba\u5927\u89c4\u6a21\u8bc4\u6d4b\u3002')))
}
if ($reviewerConcerns.Count -gt 0) {
    $risks.Add((New-Risk (U '\u8bc4\u4ef7\u98ce\u9669') "medium" $reviewerConcerns[0] (U '\u540c\u65f6\u8bb0\u5f55 attack success\u3001\u8bed\u4e49\u4fdd\u6301\u548c\u81ea\u7136\u6027\uff0c\u907f\u514d\u628a\u666e\u901a\u7f16\u8f91\u8bef\u79f0\u4e3a\u5bf9\u6297\u653b\u51fb\u3002')))
}
if ($risks.Count -eq 0) {
    $risks.Add((New-Risk (U '\u6587\u732e\u53ef\u9760\u6027\u98ce\u9669') "medium" (U '\u5f53\u524d\u603b\u7ed3\u4ecd\u5305\u542b needs manual verification\uff0c\u4e0d\u80fd\u76f4\u63a5\u5f53\u4f5c\u6700\u7ec8\u6587\u732e\u7cbe\u8bfb\u7ed3\u8bba\u3002') (U '\u540e\u7eed\u6311\u9009 2-3 \u7bc7\u6838\u5fc3\u8bba\u6587\u505a\u5168\u6587\u6838\u67e5\u3002')))
}

$data = [ordered]@{
    project = [ordered]@{
        title = "Research Idea Incubator"
        subtitle = U '\u4ece\u5bbd\u6cdb idea \u5230 research question \u7684\u79d1\u7814\u5b75\u5316\u6d41\u7a0b'
        positioning = U '\u672c\u9879\u76ee\u4e0d\u662f\u666e\u901a\u6587\u732e\u68c0\u7d22\u5de5\u5177\uff0c\u800c\u662f idea \u9a8c\u8bc1\u4e0e\u6536\u655b agent\uff1a\u6587\u732e\u641c\u7d22\u53ea\u662f\u8bc1\u636e\u6b65\u9aa4\uff0c\u6700\u7ec8\u76ee\u6807\u662f\u5f62\u6210\u53ef\u6267\u884c\u7814\u7a76\u95ee\u9898\u3002'
        status = "research_question_completed"
        generatedAt = (Get-Date).ToString("s")
    }
    idea = [ordered]@{
        raw = $rawIdea
        refined = $refinedIdea
        assumption = $assumption
        currentStage = "question"
    }
    stages = @(
        [ordered]@{ id = "idea"; name = (U '\u521d\u59cb idea'); output = (U '\u8bb0\u5f55\u672a\u7ecf\u9a8c\u8bc1\u7684\u7814\u7a76\u7075\u611f'); status = "completed" },
        [ordered]@{ id = "clarify"; name = (U '\u591a\u8f6e\u6f84\u6e05'); output = (U '\u660e\u786e\u4efb\u52a1\u3001\u573a\u666f\u3001\u7ea6\u675f\u548c\u76ee\u6807'); status = "completed" },
        [ordered]@{ id = "keywords"; name = (U '\u5173\u952e\u8bcd\u6269\u5c55'); output = (U '\u751f\u6210\u4e2d\u82f1\u6587\u5173\u952e\u8bcd\u548c\u68c0\u7d22\u5f0f'); status = "completed" },
        [ordered]@{ id = "literature"; name = (U '\u6587\u732e\u9a8c\u8bc1'); output = (U '\u68c0\u7d22\u5019\u9009\u8bba\u6587\u5e76\u603b\u7ed3\u76f8\u5173\u5de5\u4f5c'); status = "completed" },
        [ordered]@{ id = "matrix"; name = (U '\u5bf9\u6bd4\u77e9\u9635'); output = (U '\u6bd4\u8f83\u4efb\u52a1\u3001\u65b9\u6cd5\u3001\u8d21\u732e\u3001\u5c40\u9650\u548c\u5173\u7cfb'); status = "completed" },
        [ordered]@{ id = "question"; name = (U '\u7814\u7a76\u95ee\u9898'); output = (U '\u5f62\u6210 research question\u3001\u98ce\u9669\u548c\u5b9e\u9a8c\u8ba1\u5212'); status = "completed" }
    )
    clarifyingQuestions = $questions
    keywords = $keywordGroups
    papers = $papers
    risks = @($risks.ToArray())
    finalQuestion = [ordered]@{
        draft = $finalDraft
        claim = $claim
        nextExperiment = $nextExperiment
    }
}

if (-not (Test-Path -LiteralPath $DemoDir)) {
    New-Item -ItemType Directory -Path $DemoDir | Out-Null
}

$dashboardSource = Join-Path (Split-Path -Parent $PSScriptRoot) "assets\research_idea_dashboard.html"
$dashboardTarget = Join-Path $DemoDir "research_idea_dashboard.html"
if ((Test-Path -LiteralPath $dashboardSource) -and -not (Test-Path -LiteralPath $dashboardTarget)) {
    Copy-Item -LiteralPath $dashboardSource -Destination $dashboardTarget
}

$json = $data | ConvertTo-Json -Depth 12
Set-Content -LiteralPath $ProcessDataPath -Value $json -Encoding UTF8
Write-Host "Generated: $ProcessDataPath"
Write-Host "Papers: $($papers.Count); keyword groups: $($keywordGroups.Count); risks: $($risks.Count)"
