# Skill Card: Research Idea Incubator

## Skill Name

Research Idea Incubator

## Problem Solved

Early-stage research ideas are often too broad to search, evaluate, or turn directly into experiments. This skill helps users transform a vague idea into structured artifacts: idea card, keywords, candidate papers, PDF summaries, comparison matrix, risk analysis, and a final research question.

## Target Users

- Students preparing research-oriented course projects.
- Beginners who have a broad idea but do not yet know how to form a research question.
- Teams that need a traceable workflow rather than a one-shot answer.

## Inputs

- A raw research idea.
- Optional constraints, domain, datasets, methods, or target task.
- Optional paper titles, links, abstracts, or PDFs.

## Outputs

- `idea_card.md`
- `keywords.md`
- `paper_candidates.md`
- `paper_summaries.md`
- `literature_matrix.md`
- `research_question.md`
- `process_data.json` for dashboard visualization

## Workflow

1. Ask clarification questions.
2. Create a structured idea card.
3. Expand bilingual keywords and search queries.
4. Retrieve or propose candidate papers.
5. Summarize manually confirmed PDFs or paper text.
6. Build a literature comparison matrix.
7. Draft a research question with novelty and experiment risks.
8. Update a JSON state file for visualization.

## Difference From Normal ChatGPT Q&A

Normal chat often gives a single answer that mixes assumptions, suggestions, and citations in one conversation. This skill forces the research process into recoverable intermediate files. Each stage can be inspected, revised, confirmed, or reused.

The important difference is not stronger language generation. The difference is workflow control: broad idea -> structured idea -> keywords -> evidence -> comparison -> research question.

## Verification Strategy

- Mark all paper candidates and summaries as `needs manual verification` until checked.
- Keep URLs, DOI/PDF links, and search query provenance.
- Compare staged output with a baseline one-shot prompt.
- Check that every final claim can be traced back to an intermediate file.
- Keep `process_data.json` valid so the dashboard can reveal missing or incomplete stages.

## Limitations

- It does not prove novelty across all literature.
- It does not replace manual reading or systematic review.
- Free search routes can be slow, rate-limited, or incomplete.
- Native PDF input depends on the configured provider.
- Generated summaries can still misread papers and require human checking.

## Demo Case

Raw idea:

> Use diffusion models for adversarial example generation in visual-language model security. The goal is to test whether natural, semantic-preserving diffusion edits can make VLMs fail on benign captioning or VQA tasks.

Demo outputs are provided under:

```text
examples/input/
examples/output/
```
