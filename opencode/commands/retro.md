---
description: Run a harness retrospective with Mnemosyne
agent: mnemosyne
---

Perform a project retrospective for the current harness session.

Mnemosyne workflow:
1. Gather session evidence from logs, git history, and the filesystem.
2. Interview the user using the grill-me technique to extract deeper insights.
3. Produce a comprehensive retrospective report saved to `harness-journal/retro-{date}.md`.
4. Propose memory updates or documentation changes for user approval.

Any specific feedback or areas of focus provided in $ARGUMENTS will be used to guide the retrospective.

## Memory Health Phase

During every `/retro` session, Mnemosyne automatically runs the `memory-rot-detect` skill after the 5-whys grilling phase:
- Scans both server-memory (global knowledge graph) and Serena memories (project `.serena/memories/`)
- Produces a single batched proposal file at `.mnemosyne/proposals/rot-detect-<ISO8601>.md`
- Human reviews proposals and approves/rejects each before any changes are applied

Scope the memory scan using `$ARGUMENTS` (e.g., "focus on stale entries"). If `$ARGUMENTS` contains "skip memory" or similar, this phase is omitted.

