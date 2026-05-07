---
name: memory-promote
description: >
  Promote a Serena project memory (`.serena/memories/<name>.md`) into the
  server-memory knowledge graph as a global entity. Proposes first, applies
  only after explicit human approval, and uses a hash pin to abort if the
  source file mutates mid-flight.
upstream-source: "none"
upstream-commit: "none"
harness-modifications: "original"
---

## Purpose

Move a piece of durable, agent-shaping knowledge from a project-local Serena
memory into the global server-memory knowledge graph at
`~/.config/opencode/memory.json`.

Promotion is the right call when a Serena memory has proven generalizable
beyond its originating project — the curation bar in `MEMORY-POLICY.md` is met
and the knowledge should now influence agents across all projects.

This skill never deletes the source. Removal of the original Serena memory is
a separate, explicitly human-authorized step.

## Trigger

Human invokes with freeform `$ARGUMENTS` describing the target, for example:

- "promote the auth pattern from serena to global memory"
- "promote `.serena/memories/dotbot-conventions.md`"

`$ARGUMENTS` is natural language. No `--flags`.

## Fixture Mode

If the environment variable `MEMORY_FIXTURE_PATH` is set, this skill runs in
proposal-only mode. Build the proposal file as usual, but DO NOT call any
write-side MCP tools (`memory_create_entities`, `serena_*` writes). The apply
phase is disabled so tests and dry-runs are deterministic.

If `MEMORY_FIXTURE_PATH` is unset, proceed with the full propose → approve →
apply → re-verify flow described below.

## MCP Tools

**Read (always allowed):**

- `serena_get_symbols_overview` — enumerate `.serena/memories/` and locate the
  target file when `$ARGUMENTS` names it loosely.
- `serena_find_symbol` — pull the full body of the source memory file.
- `memory_search_nodes` — check whether an entity with the proposed name
  already exists in server-memory (avoid silent overwrite).
- `memory_open_nodes` — inspect the existing entity if the search hits.

**Write (apply phase only, gated by human approval and not in fixture mode):**

- `memory_create_entities` — create the new global entity.

**Forbidden in this skill:**

- `memory_delete_entities`, `memory_delete_observations`, `serena_delete_memory`
  — deletion is a separate human-gated step. Never auto-delete the Serena
  source after promotion.

## Workflow

1. **Locate source.** Use `serena_get_symbols_overview` to list
   `.serena/memories/`, then `serena_find_symbol` to read the full body of the
   file named or implied by `$ARGUMENTS`. Capture the exact content.
2. **Compute hash pin.** Compute a SHA-256 over the captured content. The
   `memory-proposal-hash` script on PATH (in `opencode/bin/`) can produce this
   if available; otherwise compute it from the captured bytes. Record this
   hash as the *pin*. The pin is what guarantees the file has not changed
   between proposal and apply.
3. **Distill into entity shape.** Decide the target entity's `name`,
   `entityType`, and `observations[]`. Observations should be durable,
   single-fact statements aligned with `MEMORY-POLICY.md`. Strip transient
   context, project-specific paths, and anything that fails the curation bar.
4. **Check for collisions.** Call `memory_search_nodes` with the proposed
   entity name. If an entity already exists, surface this in the proposal —
   the human must decide whether to merge, rename, or abort.
5. **Write proposal.** Write a single proposal file to:

   ```
   .mnemosyne/proposals/promote-<ISO8601>.md
   ```

   `<ISO8601>` is the current UTC timestamp with colons replaced by hyphens
   for filesystem safety, e.g. `promote-2026-04-30T14-22-05Z.md`.

   Proposal contents:

   ```
   # Memory Promotion Proposal — <ISO8601>

   Source: .serena/memories/<name>.md
   Hash pin: <sha256>
   Fixture: <path or "none">
   Existing entity collision: <yes/no — name>

   ## Target entity

   name: <entity-name>
   entityType: <type>
   observations:
     - <observation 1>
     - <observation 2>
     - ...

   ## Approval required

   Reply "approve" to apply, "reject" to abort, or supply edits.
   Source memory will NOT be deleted automatically — that is a separate step.
   ```

6. **Stop here in fixture mode.** If `MEMORY_FIXTURE_PATH` is set, the skill
   ends after writing the proposal. Do not call any write tools.
7. **Wait for explicit human approval.** Do not infer approval from silence,
   ambiguity, or partial replies. The human must say "approve" (or
   equivalent) on this specific proposal.
8. **Re-read source and re-verify pin.** Before any write, call
   `serena_find_symbol` again on the source file, recompute the hash, and
   compare to the pin. If the hash differs, ABORT. Write a brief abort note
   to the proposal file and surface the mismatch to the human. Do not apply.
9. **Apply.** Call `memory_create_entities` with the approved entity. If the
   collision check at step 4 found an existing entity and the human
   authorized a merge, prefer creating a renamed entity over silently
   overwriting — `memory_create_entities` is additive, not idempotent on
   identical names.
10. **Ask about source removal.** After successful creation, ask the human
    whether the original Serena memory should be deleted. Do NOT delete
    automatically. If the human approves deletion, that is handled by a
    separate skill or explicit `serena_delete_memory` call — not by this
    skill.

## Anti-patterns

- **Auto-deleting the Serena source.** Never. Always ask.
- **Skipping the hash re-verify.** A file can change between proposal and
  apply. The pin exists exactly to catch that. Aborting is correct behaviour.
- **Promoting transient or project-specific knowledge.** Re-read
  `MEMORY-POLICY.md`. If the source memory contains paths like
  `/Users/<name>/...`, in-flight TODOs, or session-scoped facts, reject the
  promotion in the proposal itself.
- **Silent merge into an existing entity.** Collisions must be visible in the
  proposal. The human picks the resolution.
- **Bash calls inside the skill body.** Skills are agent instructions, not
  scripts. The agent may invoke tools like `memory-proposal-hash` if the
  human authorized them, but this skill does not hardcode shell commands.
- **`--flag` arguments.** `$ARGUMENTS` is freeform natural language.

## Out of Scope

- Demotion (server-memory → Serena). See `memory-demote`.
- Bulk promotion. One proposal per invocation. Batch curation lives in
  `memory-rot-detect` + per-item promote/demote.
- Rewriting the source memory. Promotion copies; it does not edit `.serena/`.
