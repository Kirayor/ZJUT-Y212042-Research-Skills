# Research Idea Incubator Output Schema

## 1. Idea Card

File:

```text
research_idea_agent/outputs/idea_card.md
```

Schema:

```markdown
# Idea Card

## Raw Idea

## Refined Problem

## Target Task

## Motivation

## Core Assumption

## Possible Contribution

## Required Evidence

## Unknowns

## Next Questions
```

## 2. Keywords

File:

```text
research_idea_agent/outputs/keywords.md
```

Schema:

```markdown
# Keywords

## Core Terms

## Method Terms

## Domain Terms

## Dataset Terms

## Evaluation Terms

## Chinese Keywords

## Search Queries

## Negative Keywords
```

## 3. Paper Summary

File:

```text
research_idea_agent/outputs/paper_summaries.md
```

Use this schema for every paper:

```markdown
## Paper: <title>

- Year / Venue:
- Source:
- Problem:
- Method:
- Key Contribution:
- Dataset:
- Metrics:
- Main Results:
- Limitation:
- Relation to My Idea:
- Citation Confidence: high / medium / low / needs manual verification
```

## 4. Literature Matrix

File:

```text
research_idea_agent/outputs/literature_matrix.md
```

Schema:

```markdown
# Literature Comparison Matrix

| Paper | Task | Method | Data | Contribution | Limitation | Relation to idea | Verification |
|---|---|---|---|---|---|---|---|
```

## 5. Research Question

File:

```text
research_idea_agent/outputs/research_question.md
```

Schema:

```markdown
# Research Question

## Candidate Research Question

## Why This Question Matters

## Potential Novelty

## Novelty Risk

## Experiment Risk

## Minimal Experiment Plan

## Expected Evidence

## Reviewer Concerns

## Next Papers to Verify Manually
```

## 6. Visualization JSON

File:

```text
research_idea_demo/process_data.json
```

Purpose:

This file drives the local visualization dashboard. Keep it valid JSON.

Preferred generation method:

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\14-research-idea-incubator\scripts\Generate-ProcessData.ps1
```

Required top-level fields:

```json
{
  "project": {},
  "idea": {},
  "stages": [],
  "clarifyingQuestions": [],
  "keywords": {},
  "papers": [],
  "risks": [],
  "finalQuestion": {}
}
```
