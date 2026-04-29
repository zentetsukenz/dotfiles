# Harness Journal

Personal development harness — feedback loops, retrospectives, and changelog.

## Layout

- `harness-changelog.md` — Master append-only log of all harness observations
- `feedback-{date}.md` — Session feedback (e.g., `feedback-2026-04-29.md`)
- `retro-{date}.md` — Retrospectives and learnings (e.g., `retro-2026-04-29.md`)

## Retention Policy

Manual maintenance. No automatic rotation or archival. Entries are indefinite.

## Multi-Machine Note

Each machine maintains its own journal. Divergence is acceptable and expected. Journals are not synced across machines — they reflect local development context and learnings.

## Usage

1. After each session, append observations to `harness-changelog.md`
2. Create dated feedback/retro files as needed
3. No git hooks — all updates are manual
4. Mnemosyne integration (Task 6+) will symlink journal files to `~/.config/opencode/harness-journal/`
