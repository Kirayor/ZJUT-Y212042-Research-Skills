# Research Idea Incubator Staged Workflow

This workflow is designed for staged automation with human confirmation between stages.

## Stage 1: Idea Clarification

Goal:

- Ask 3-5 targeted questions.
- Do not produce final research question yet.

Outputs:

- `research_idea_agent/outputs/idea_card.md` draft
- `research_idea_demo/process_data.json` partial update

Gate:

- Wait for user confirmation before Stage 2.

## Stage 2: Idea Card and Keyword Expansion

Goal:

- Refine the raw idea into a structured idea card.
- Generate bilingual keywords, synonyms, method terms, task terms, dataset terms, evaluation terms, and negative keywords.

Outputs:

- `research_idea_agent/outputs/idea_card.md`
- `research_idea_agent/outputs/keywords.md`
- `research_idea_demo/process_data.json`

Gate:

- Wait for user confirmation before Stage 3.

## Stage 3: Paper Search

Goal:

- Use the keywords to generate paper search queries.
- Search for candidate papers when tools are available.
- Prefer OpenClaw `web_fetch` + OpenAlex API as the no-card/free primary route.
- Use OpenClaw `web_search` as a fallback for general web discovery; DuckDuckGo may be slow or timeout because it is HTML-based.
- Return paper title, year, venue/source, URL, and relevance.
- Do not invent citations.

Outputs:

- `research_idea_agent/outputs/paper_candidates.md`
- update `research_idea_demo/process_data.json`

Gate:

- Wait for user to confirm candidate papers or manually place PDFs in `research_idea_agent/papers`.

## Stage 4: PDF Summary

Goal:

- Read PDFs from `research_idea_agent/papers`.
- Prefer manually confirmed PDFs or provider-native PDF reading configured outside this submitted skill folder.
- Use summarize skill or PDF-to-text only as fallback routes.
- Summarize each paper with the schema in `OUTPUT_SCHEMA.md`.

Outputs:

- `research_idea_agent/outputs/paper_summaries.md`

Gate:

- Wait for user confirmation before Stage 5.

## Stage 5: Literature Matrix

Goal:

- Compare papers by task, method, data, contribution, limitation, relation to idea, and verification status.

Outputs:

- `research_idea_agent/outputs/literature_matrix.md`
- update `research_idea_demo/process_data.json`

Gate:

- Wait for user confirmation before Stage 6.

## Stage 6: Research Question

Goal:

- Form candidate research question.
- Identify novelty risk, experiment risk, reviewer concerns, and minimal experiment plan.

Outputs:

- `research_idea_agent/outputs/research_question.md`
- final update to `research_idea_demo/process_data.json`

Gate:

- Stop and ask user whether to revise, search more papers, or prepare final report/PPT.
