---
name: memory-demote
description: >
  Demote a server-memory entity into a Serena project memory file
  (`.serena/memories/<name>.md`). Proposes first, applies only after explicit
  human approval, and uses a hash pin to abort if the written file does not
  match the approved content.
upstream-source: "none"
upstream-commit: "none"
harness-modifications: "original"
---

## Purpose

Move knowledge from the global server-memory knowledge graph into a
project-local Serena memory. Demotion is the right call when an entity in
server-memory turns out to be project-specific, narrowly scoped, or no longer
clearing the curation bar in `MEMORY-POLICY.md` — but is still useful to keep
adjacent to the project that owns it.

This skill never deletes the source entity. Removal of the original
server-memory entry is a separate, explicitly human-authorized step.

## Trigger

Human invokes with freeform `$ARGUMENTS` describing the target, for example:

- "demote the dotfiles entity to project memory"
- "demote server-memory entity `OldAuthFlow` into this project"

`$ARGUMENTS` is natural language. No `--flags`.

## Fixture Mode

If the environment variable `MEMORY_FIXTURE_PATH` is set, this skill runs in
proposal-only mode. Build the proposal file as usual, but DO NOT call any
write-side MCP tools (`serena_write_memory`, etc.). The apply phase is
disabled so tests and dry-runs are deterministic.

If `MEMORY_FIXTURE_PATH` is unset, proceed with the full propose → approve →
apply → re-verify flow described below.

## MCP Tools

**Read (always allowed):**

- `memory_search_nodes` — locate the target entity when `$ARGUMENTS` names it
  loosely.
- `memory_open_nodes` — pull the full entity payload (entityType, full
  observation list, relations) for the proposal.
- `serena_get_symbols_overview` — check whether a Serena memory with the
  proposed filename already exists in `.serena/memories/`.
- `serena_find_symbol` — read back the just-written Serena file for hash
  re-verification.

**Write (apply phase only, gated by human approval and not in fixture mode):**

- `serena_write_memory` — create the new project-local memory file.

**Forbidden in this skill:**

- `memory_delete_entities`, `memory_delete_observations`, `serena_delete_memory`
  — deletion is a separate human-gated step. Never auto-delete the
  server-memory source after demotion.

## Workflow

1. **Locate source entity.** Use `memory_search_nodes` to find the entity
   named or implied by `$ARGUMENTS`. Then `memory_open_nodes` to fetch the
   full payload: `name`, `entityType`, `observations[]`, and any relations
   that should travel with it.
2. **Render to Serena content.** Compose the markdown body that will become
   `.serena/memories/<name>.md`. Suggested shape:

   ```
   # <entity-name>

   Type: <entityType>

   ## Observations

   - <observation 1>
   - <observation 2>
   - ...

   ## Relations (informational)

   - <from> --<relationType>--> <to>
   - ...
   ```

3. **Compute pre-write hash pin.** Compute SHA-256 over the exact bytes that
   will be written. Record this hash as the *pin*. The pin guarantees the
   apply phase wrote what was approved, byte-for-byte.
4. **Check for filename collisions.** Use `serena_get_symbols_overview` on
   `.serena/memories/` to verify no file with the proposed name already
   exists. If one does, surface this in the proposal — the human must
   decide whether to overwrite, rename, or abort.
5. **Write proposal.** Write a single proposal file to:

   ```
   .mnemosyne/proposals/demote-<ISO8601>.md
   ```

   `<ISO8601>` is the current UTC timestamp with colons replaced by hyphens
   for filesystem safety, e.g. `demote-2026-04-30T14-22-05Z.md`.

   Proposal contents:

   ```
   # Memory Demotion Proposal — <ISO8601>

   Source entity: <entity-name>
   Target file: .serena/memories/<name>.md
   Hash pin: <sha256>
   Fixture: <path or "none">
   Existing file collision: <yes/no>

   ## Proposed file body

   ```
   <full markdown content as it will be written>
   ```

   ## Approval required

   Reply "approve" to apply, "reject" to abort, or supply edits.
   Source entity will NOT be deleted automatically — that is a separate step.
   ```

6. **Stop here in fixture mode.** If `MEMORY_FIXTURE_PATH` is set, the skill
   ends after writing the proposal. Do not call any write tools.
7. **Wait for explicit human approval.** Do not infer approval from silence,
   ambiguity, or partial replies. The human must say "approve" (or
   equivalent) on this specific proposal.
8. **Apply.** Call `serena_write_memory` with the approved content for the
   target memory name. The `memory-proposal-hash` tool on PATH (in
   `opencode/bin/`) may be used to verify the byte stream if the human
   authorized it.
9. **Re-read and re-verify pin.** After the write, call `serena_find_symbol`
   to read back the just-written file. Recompute SHA-256 over its exact
   bytes and compare to the pin from step 3. If the hash differs, ABORT:
   the file on disk does not match what was approved. Write a brief abort
   note to the proposal file and surface the mismatch to the human. Do not
   proceed to source-deletion confirmation while in a mismatched state.
10. **Ask about source removal.** After successful, hash-verified write, ask
    the human whether the original server-memory entity should be deleted.
    Do NOT delete automatically. If the human approves deletion, that is
    handled by a separate skill or explicit `memory_delete_entities` call —
    not by this skill.

## Anti-patterns

- **Auto-deleting the server-memory source.** Never. Always ask.
- **Skipping the hash re-verify.** Filesystem write paths can transform line
  endings, normalize whitespace, or fail silently. The pin exists exactly to
  catch that. Aborting on mismatch is correct behaviour.
- **Silent overwrite of an existing Serena file.** Collisions must be visible
  in the proposal. The human picks the resolution.
- **Demoting knowledge that should simply be deleted.** If the entity fails
  the curation bar AND has no project-local value, propose deletion instead
  of demotion — demotion is for relocation, not for graveyards.
- **Bash calls inside the skill body.** Skills are agent instructions, not
  scripts. The agent may invoke tools like `memory-proposal-hash` if the
  human authorized them, but this skill does not hardcode shell commands.
- **`--flag` arguments.** `$ARGUMENTS` is freeform natural language.

## Out of Scope

- Promotion (Serena → server-memory). See `memory-promote`.
- Bulk demotion. One proposal per invocation. Batch curation lives in
  `memory-rot-detect` + per-item promote/demote.
- Rewriting the source entity. Demotion copies; it does not edit
  server-memory in place.
