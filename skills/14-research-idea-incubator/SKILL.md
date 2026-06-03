---
name: research-idea-incubator
description: Transform a broad or vague academic research idea into a literature-grounded research question through staged clarification, keyword expansion, paper discovery, PDF/paper summarization, comparison matrices, risk analysis, and visualization artifacts. Use when the user wants help with early-stage research planning, idea validation, literature-grounded ideation, research-question generation, OpenClaw-based research workflows, or a course project skill that records intermediate Markdown/JSON outputs instead of only answering in chat.
---

# Research Idea Incubator

## Purpose

Use this skill to turn an early research idea into a traceable research-planning package. The goal is not to replace literature review or fully automate scientific discovery. The goal is to make idea clarification, keyword expansion, literature evidence, comparison, and final research-question formation visible as staged artifacts.

Central claim:

> This is not a literature retrieval agent. It is an idea validation and convergence agent: literature search is an intermediate evidence step, while the final goal is to form a stronger research question.

## Required Outputs

For a new idea, first create or identify an active run folder:

```text
research_idea_agent/outputs/<idea-slug>-<timestamp>/
```

Use `scripts/New-IdeaOutputRun.ps1` when command execution is available. Keep the active run in `research_idea_agent/outputs/current_run.json`.

During interactive work, also keep these current workspace files updated for compatibility with the dashboard and existing scripts:

```text
research_idea_agent/outputs/idea_card.md
research_idea_agent/outputs/keywords.md
research_idea_agent/outputs/paper_candidates.md
research_idea_agent/outputs/paper_summaries.md
research_idea_agent/outputs/literature_matrix.md
research_idea_agent/outputs/research_question.md
research_idea_demo/process_data.json
```

At the end of each stage, copy the corresponding artifacts into the active run's `artifacts/` folder. The shared files are convenient working copies; the run folder is the archival record for one idea.

If command execution is not available, create the same folder structure manually:

```text
research_idea_agent/outputs/<idea-slug>-<timestamp>/
├── README.md
├── input_idea.txt
├── run_meta.json
├── artifacts/
└── papers/
```

Use `references/OUTPUT_SCHEMA.md` for exact file schemas.

## Workflow

Follow the stages below. Stop at each gate when the user needs to confirm or provide PDFs.

1. **Idea clarification**
   Ask 3-5 targeted questions. Do not jump to the final research question.

2. **Idea card**
   Write the raw idea, refined problem, target task, motivation, assumptions, possible contribution, unknowns, and next questions.

3. **Keyword expansion**
   Generate English/Chinese core terms, method terms, domain terms, dataset terms, evaluation terms, search queries, and negative keywords.

4. **Paper discovery**
   Prefer OpenAlex API metadata through available fetch/search tools. Use direct paper metadata only; do not invent citations. Mark all candidates as `needs manual verification`.

5. **PDF or paper summarization**
   If PDFs are available, summarize them with the fixed paper-summary schema. Prefer native PDF input when the provider supports it. Fall back to summarize tools or converted text only when necessary.

6. **Literature matrix**
   Compare papers by task, method, data, contribution, limitation, relation to the idea, and verification status.

7. **Research question**
   Draft the candidate research question, sub-questions, novelty risk, experiment risk, reviewer concerns, and minimal experiment plan.

8. **Visualization state**
   Keep `process_data.json` valid and synchronized so the dashboard can display the idea path, papers, risks, and final question. Prefer running `scripts/Generate-ProcessData.ps1` instead of manually composing JSON.

## Paper Search Rules

- Prefer API-backed metadata such as OpenAlex:

```text
https://api.openalex.org/works?search=<url-encoded-query>&per-page=5
```

- Use DuckDuckGo/web search only as fallback; it may timeout or return unstable HTML results.
- Treat Semantic Scholar anonymous requests as optional because they may return `429 Too Many Requests`.
- Keep source URL, DOI, PDF URL if available, and search query for every candidate.
- Never use a paper as evidence until its title/source/claims have been checked.
- If no reliable search tool is available, output high-quality manual search queries instead of pretending the search succeeded.

## PDF Handling Rules

- Put PDFs under `research_idea_agent/papers/` or a run-specific `papers/` folder.
- Prefer manually confirmed PDFs or provider-native PDF reading when available.
- This submitted skill does not include provider-specific API scripts. Users should configure PDF reading in their own OpenClaw environment and keep API credentials outside the skill folder.
- Keep citation confidence as `needs manual verification` unless a human has checked the paper.
- Do not upload or print API keys, OpenClaw tokens, or `~/.openclaw/openclaw.json`.

## Useful Bundled Resources

- `references/OUTPUT_SCHEMA.md`: exact Markdown/JSON output schemas.
- `references/WORKFLOW_STAGES.md`: stage gates and expected artifacts.
- `scripts/New-IdeaOutputRun.ps1`: create a timestamped output folder for one idea.
- `scripts/Download-PaperCandidates.ps1`: download only explicit PDF URLs from candidate lists.
- `scripts/Generate-ProcessData.ps1`: generate `research_idea_demo/process_data.json` from the Markdown artifacts for the dashboard.
- `scripts/Start-ResearchDashboard.ps1`: serve the dashboard locally for demos.
- `assets/research_idea_dashboard.html`: dashboard template for visualizing `process_data.json`.
- `examples/input/`: sample initial idea.
- `examples/output/`: known-good artifacts from a completed demo run.

## Safety And Scope

Use conservative permissions when the model is connected through a third-party relay. Do not request broad local command execution when file outputs are enough. Prefer writing only inside the project workspace. Keep all generated literature claims visibly marked as model-generated until manually verified.

Do not claim the skill performs a complete systematic review, proves novelty, or replaces human scholarly judgment. Claim that it records and supports the early research-planning process.
