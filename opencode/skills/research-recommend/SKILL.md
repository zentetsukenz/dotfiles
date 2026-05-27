---
name: research-recommend
description: Use ONLY for comparative research that informs a concrete decision through multi-candidate comparison, literature review, and a multi-file paper-style report. NOT for single-source lookups (use librarian), quick fact-checks, or library docs queries.
disable-model-invocation: true
---

# Research Recommend

A disciplined workflow for comparative research that turns a broad topic into a reproducible findings package and a recommendation. Use it when the user needs multiple viable candidates compared against explicit criteria before making a decision.

Do not use this skill for PRDs, issue creation, code execution, one-off documentation lookup, or quick factual answers.

## Phase 1 — Intake + vagueness check

Require both:

- A concrete topic.
- The decision the comparative research is meant to inform.

If the prompt is fewer than 3 words, or if it lacks decision context, ask exactly one clarifying question before continuing.

Ask for the topic slug, or derive it by lowercasing the topic, replacing non-alphanumeric runs with `-`, and trimming leading/trailing hyphens.

## Phase 2 — Parameter intake

Use matrix parameters the user provides. If none are provided, infer a comparison matrix from the topic and decision context.

Always show the inferred parameter set before evaluation. Let the user confirm or refine it before scoring candidates.

The parameter set should include evaluation criteria, disqualifiers, and any project constraints needed for a useful recommendation.

## Phase 3 — Parallel max-breadth search

Search broadly and in parallel across these sources:

1. Web search with Exa/websearch.
2. GitHub examples with `grep_app_searchGitHub`.
3. Library documentation with Context7 (`context7_resolve-library-id` and `context7_query-docs`).

Evaluate at least 5 candidates when 5 viable candidates exist. If fewer than 5 viable candidates are found, state that explicitly and do not pad with weak candidates.

Log every query as you run it to `search-log.md`, including source, query text, date, and why the query was used.

## Phase 4 — Shortlist presentation + interactive loop

Present the shortlist before deep-dive work. For each candidate, show a one-line rationale and any obvious risk.

Ask the user to choose one of:

- `accept` — proceed with the shortlist.
- `edit candidates` — add, remove, or rename candidates.
- `refine query` — change the search direction and repeat Phase 3.

Loop until the user confirms the shortlist. Ask one question at a time when candidate edits or query refinements are ambiguous.

## Phase 5 — Deep-dive on confirmed candidates

For each confirmed candidate:

- Use `webfetch` on the top relevant URLs.
- Use Context7 `query-docs` for libraries with available documentation.
- Capture strengths, weaknesses, constraints, maturity signals, maintenance signals, integration cost, and decision-specific fit.

Keep the analysis comparative. Do not turn the deep dive into unrelated implementation planning.

## Phase 6 — Write outputs

Write a dated output folder and never overwrite a previous run.

Default path:

```text
.omo/research-recommended/<topic-slug>-<YYYY-MM-DD>/
```

Use a user-specified folder instead when provided. For re-runs on the same day, choose a new non-overwriting folder name such as `-2`, `-3`, or a more specific slug.

Write these files:

- `findings.md` — literature review, candidate matrix, and comparative analysis.
- `recommendation.md` — decision-oriented recommendation with rationale and caveats.
- `search-log.md` — every query, source, date, and purpose.
- `references.md` — paper-style citation list with titles, URLs, and access dates.

Before finishing, verify the output folder exists, all four files exist, the candidate count policy is stated, and the recommendation traces back to the confirmed matrix parameters.
