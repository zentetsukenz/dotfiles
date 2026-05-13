---
name: qa-witness-protocol
description: Protocol for declaring and invoking the qa-witness team. Loaded explicitly by Prometheus when a plan involves behavioral verification (UI/API/CLI/file artifacts). Defines the args schema, plan template section, and per-task workflow contract.
---

## 1. When to load this skill
Prometheus explicit decision — 'Does this plan produce or modify a behavioral artifact (rendered UI, HTTP endpoint, CLI tool, generated file)? If YES, load this skill. If NO (pure refactor of internals, prompt/config edits, doc-only), skip.'

## 2. QA Witness Setup section template
Verbatim plan template block Prometheus inserts:

```markdown
## QA Witness Setup
- **Workflow Doc**: ./QA-WITNESS.md (run /init-qa-witness if missing)
- **Server lifecycle**: task-scoped (Sisyphus starts before each task flagged below, tears down after)
- **Seed strategy**: <inline command OR reference to QA-WITNESS.md section>
- **Tasks requiring visual verification**: T<n>, T<m> (see flag below in TODO entries)
```

## 3. Per-task flag
Prometheus marks tasks with `**Visual Verification**: YES | NO` in TODO entry.

## 4. Per-member message payload schema
Per-member message payload schema (sent by Sisyphus via team_send_message after team_create):

```json
{
  "url": "http://localhost:3000",
  "task_id": "T5",
  "scenario": {
    "surface": "ui|api|cli|artifact",
    "name": "login-happy-path",
    "steps": ["navigate /login", "fill email", "click submit"],
    "expected": "text 'Welcome back' appears within 5s",
    "evidence_path": ".sisyphus/evidence/task-T5-login-happy-path.png"
  }
}
```

Note: Sisyphus sends ONE message per scenario per member. Multiple scenarios → multiple sequential messages.

## 5. Verdict policy
STRICT verdict policy — any witness FAIL = team REJECT. Sisyphus blocks task-complete on REJECT. Witness timeout (>120s default) = FAIL.

## 6. Visual cost mitigation
Witnesses describe verbally + save evidence to disk. Lead aggregates verdicts only. NO image bytes in messages.

## 7. Evidence convention
Evidence convention — `.sisyphus/evidence/task-{task_id}-{scenario_slug}.{ext}`. Gitignored via existing `.sisyphus/` rule. No redaction (trust local dev env).

## 8. Recursion guard reminder
Recursion guard reminder — Lead must not invoke qa-witness recursively (already in team config, repeated here for skill readers).

## 9. Conditional ui-witness
Conditional ui-witness — If the plan-task's QA Scenarios list contains zero entries with `surface: 'ui'`, ui-witness is skipped for that task. Lead enforces. Note: per-message wire payload is always singular `{ url, task_id, scenario }`.
