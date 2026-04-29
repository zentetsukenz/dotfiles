# Task 24 — Prometheus vs domain-model Audit

## Source Resolution
- Case B applied. `opencode/oh-my-openagent.json` returned `NO_OVERRIDE` for `.agents.prometheus.prompt`, so there is no local prompt override.
- Audit subject came from the upstream OMO built-in prompt on branch `dev`, centered on `src/agents/prometheus/system-prompt.ts` and its composed sections: `identity-constraints.ts`, `interview-mode.ts`, `plan-generation.ts`, `high-accuracy-mode.ts`, `plan-template.ts`, and `behavioral-summary.ts`.
- The local config also shows `agents.prometheus.skills = ["domain-model"]`, so this audit compares the upstream planner prompt against a locally bound skill rather than against a local prompt fork.

## Shared Phrases/Patterns
- Both are question-driven instead of implementation-driven: Prometheus defaults to interview mode, and `domain-model` says to "interview me relentlessly".
- Both expect codebase exploration before making assertions. Prometheus requires research-backed consultation; `domain-model` explicitly says to explore the codebase when a question can be answered there.
- Both are designed to sharpen understanding before downstream work proceeds.
- Both are opinionated, not passive: Prometheus makes recommendations during planning, and `domain-model` says each question should include a recommended answer.

## Prometheus-only Behaviors
- Prometheus has a hard identity boundary: planner only, never implementer, markdown-only outputs, and strict forbidden actions.
- Prometheus owns the full planning workflow: intent classification, clearance checks, auto-transition to plan generation, Metis consultation, plan templating, and `/start-work` handoff.
- Prometheus manages orchestration mechanics that `domain-model` does not mention: todo registration, draft cleanup, high-accuracy Momus loop, and `.sisyphus/plans/*.md` production.
- Prometheus optimizes for delivery structure and execution readiness, not just conceptual clarity.

## domain-model-only Behaviors
- `domain-model` is specifically about stress-testing a plan against the project's language, glossary, and bounded contexts.
- It pushes terminology discipline harder than Prometheus: call out glossary conflicts, sharpen overloaded terms, and force canonical naming.
- It asks for concrete domain scenarios and edge-case probing to pressure-test relationships between concepts.
- It requires documentation behavior that Prometheus does not: update `CONTEXT.md` inline when terms are resolved and offer ADRs only when reversibility, surprise, and trade-off criteria are all met.
- It is interactive at a finer grain: one question at a time, waiting for feedback before continuing.

## Recommendation
- Keep both.
- Reason: Prometheus covers planner identity, workflow control, and plan-file generation, while `domain-model` adds a narrower pre-bind capability for domain language, glossary conflict detection, scenario probing, and inline domain documentation updates.
- Overriding Prometheus just to absorb `domain-model` would collapse two different concerns into one large planner prompt; binding the skill is the cleaner separation because it enriches planning without duplicating Prometheus's orchestration rules.
