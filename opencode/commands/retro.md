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
