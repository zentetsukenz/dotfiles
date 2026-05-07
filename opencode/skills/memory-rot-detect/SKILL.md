---
name: memory-rot-detect
description: >
  Scan both server-memory (knowledge graph) and Serena memories for context rot
  — duplicates, stale entries, sensitive data, transient context, and bloat —
  and produce a single batched proposal file for human review. Read-only:
  proposes only, never applies changes.
upstream-source: "none"
upstream-commit: "none"
harness-modifications: "original"
---

## Purpose

Detect context rot across BOTH memory stores Mnemosyne curates:

- **server-memory** (the `memory` MCP knowledge graph at `~/.config/opencode/memory.json`)
- **Serena memories** (`.serena/memories/*.md` files in the active project)

Memory rot accumulates silently. Without periodic detection, both stores drift toward
bloat, duplication, and policy violations — directly contradicting `MEMORY-POLICY.md`.
This skill is the *detection* half of curation. Acting on findings is gated behind a
human review of the produced proposal file.

## Trigger

- **Auto-loaded** during the Mnemosyne retro memory-health phase.
- **Standalone**: invoke when the user asks to "audit memory", "check for rot",
  "scan memories", or supplies `$ARGUMENTS` describing a focused scan
  (e.g. "look for stale entries about the old API"). `$ARGUMENTS` is freeform
  natural language — no `--flags`.

## Fixture Mode

If the environment variable `MEMORY_FIXTURE_PATH` is set, treat it as the path
to a JSON file shaped like:

```json
{
  "server_memory": {
    "entities": [ { "name": "...", "entityType": "...", "observations": ["..."], "lastUpdated": "ISO8601" } ],
    "relations": [ { "from": "...", "to": "...", "relationType": "..." } ]
  },
  "serena_memories": [
    { "path": ".serena/memories/<name>.md", "content": "...", "lastUpdated": "ISO8601" }
  ]
}
```

In fixture mode, do NOT call any live MCP tools. Read the fixture file and run
the same detection categories against its contents. This makes the skill
deterministic for tests and dry-runs.

If `MEMORY_FIXTURE_PATH` is unset, use the live MCP tools listed below.

## MCP Tools

**server-memory** (read-only here):

- `memory_search_nodes` — broad scan; query with topical terms drawn from
  `MEMORY-POLICY.md` admit/reject categories. Iterate across multiple queries
  to surface a representative sample.
- `memory_open_nodes` — deep inspection of suspicious entities found via
  search. Use to read full observation lists before classifying as duplicate
  or bloat.

**Serena**:

- `serena_get_symbols_overview` — list `.serena/memories/` to enumerate memory
  files and their top-level structure.
- `serena_find_symbol` — pull the body of a specific memory file when content
  inspection is needed (e.g. checking for sensitive patterns).

Never call write tools. Never call `memory_create_*`, `memory_delete_*`,
`memory_add_observations`, `serena_write_memory`, or `serena_delete_memory`.

## Detection Categories

Scan for ALL five categories in a single pass per store:

1. **Duplicates** — entities or observations that express the same fact in
   different words. Flag near-paraphrases, not just exact matches. Two
   entities about the same concept with overlapping observations count.
2. **Stale** — entities whose `lastUpdated` (or equivalent) is older than
   30 days AND which are not referenced by recent relations or other recently
   updated entities. Pure age is not enough; absence of recent connection is
   the second criterion.
3. **Sensitive** — observations containing patterns that violate
   `MEMORY-POLICY.md`:
   - Email addresses (`\S+@\S+\.\S+`)
   - API keys / tokens (long alphanumeric strings, `sk-…`, `ghp_…`, `AKIA…`,
     hex strings ≥32 chars)
   - Absolute home paths (`/Users/<name>/…`, `/home/<name>/…`)
   - Phone numbers (E.164 or common national formats)
4. **Transient** — observations describing temporary state. Keywords:
   "currently", "right now", "today", "this session", "at the moment",
   "for now", "temporarily". Memory is for *durable* knowledge; transient
   facts belong in notepads.
5. **Bloat** — entities with more than 10 observations. Flag these as
   candidates for summarization or splitting into narrower entities.

## Output Format

Write a SINGLE batched proposal file (not one file per finding) to:

```
.mnemosyne/proposals/rot-detect-<ISO8601>.md
```

`<ISO8601>` is the current UTC timestamp, e.g. `rot-detect-2026-04-30T14-22-05Z.md`
(colons replaced with hyphens for filesystem safety).

File contents:

```
# Memory Rot Detection — <ISO8601>

Scope: server-memory + serena-memories
Fixture: <path or "none">

## Proposals

[1] server-memory/<entity-name>: duplicate — overlaps with <other-entity>
[2] server-memory/<entity-name>: stale — last touched <date>, no recent refs
[3] server-memory/<entity-name>: sensitive — contains email pattern
[4] server-memory/<entity-name>: transient — observation uses "currently"
[5] server-memory/<entity-name>: bloat — 14 observations, candidate for split
[6] serena/<file>.md: duplicate — restates server-memory entity <name>
...

Total: <N> proposals. Review and approve/reject each before applying.
```

Each line is one proposal. Format strictly:
`[N] <store>/<entity-or-file>: <issue-type> — <one-line description>`

`<store>` is `server-memory` or `serena`.
`<issue-type>` is one of: `duplicate`, `stale`, `sensitive`, `transient`, `bloat`.

## Apply Phase

**DISABLED.** This skill proposes only. To act on a proposal, the human must
invoke `memory-promote` (to keep+rewrite) or `memory-demote` (to remove) on
specific items from the proposal file. Mnemosyne MUST NOT auto-apply, even if
findings look unambiguous. The human review gate is non-negotiable — it is
the only safeguard against false positives erasing real institutional memory.

## Batch Constraint

All findings from a single scan land in ONE proposal file. Do not split per
category, per store, or per entity. The reviewer needs a unified view to
spot patterns (e.g. "all five sensitive findings are in the same entity →
one demotion fixes them all").

## Out of Scope

- No bash scripts. No filesystem writes outside `.mnemosyne/proposals/`.
- No edits to `~/.config/opencode/memory.json` or `.serena/memories/`.
- No network calls.
- No `--flag` arguments — `$ARGUMENTS` is freeform.
