---
description: Generate user-facing release notes from git history
agent: quick
---

Generate release notes for the following version range: $ARGUMENTS

If no version range is provided, use the range from the last git tag to HEAD.
Use `git log --oneline <range>` to get the raw commit history.

Focus ONLY on changes that impact the user's day-to-day operation:
- What new capabilities do they gain?
- What existing behavior changed that they need to adapt to?
- What bugs were fixed that they might have been experiencing?

Group changes into these sections (omit empty sections):
## Features
## Improvements
## Bug Fixes

Rules:
- Rewrite each change in plain language — no jargon, no commit hashes, no file paths
- Omit internal/infrastructure changes unless they have a user-visible effect
- Each item should answer: "What does this mean for the user?"
- Keep descriptions to one sentence each
