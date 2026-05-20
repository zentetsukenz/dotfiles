---
description: Initialize QA Witness Workflow Doc for current project. Scans project, grills user on dev-server setup, writes QA-WITNESS.md at repo root. May fail with setup-recommendation if project has no reliable dev server.
---

For per-task deliverable verification, load the `qa-witness-protocol` skill. This command initializes the QA Witness workflow doc for a project.

### Scan phase
Detect these files/patterns to identify potential dev server commands:
- `package.json`: Read scripts, look for keys containing `dev`, `start`, `serve`, or `preview`.
- `Cargo.toml`, `Gemfile` + `bin/rails`, `mix.exs`, `go.mod`, `pyproject.toml`, `requirements.txt`.
- `Makefile`, `justfile`, `Taskfile.yml`, `docker-compose.yml`, `.env.example`.

Specific language heuristics:
- Node.js: Enumerate scripts matching `dev|start|serve|preview`.
- Rails: Check for `bin/rails server` and required setup like `db:prepare`.
- Phoenix: Check for `mix phx.server`.
- Docker Compose: List services and identify which one exposes a port.

If no candidates are found, declare 'no dev server detected'.

### Grill phase
Interview the user using the detected candidates to finalize the workflow:
- Present candidates as Question-tool options: 'Which command starts your dev server?'
- Ask: 'How do we know it's ready?' (URL probe / log line / fixed delay).
- Ask: 'Seed strategy?' (none / inline command / DB script / API seed call).
- Ask: 'Teardown?' (kill PID / docker compose down / nothing).

If the user responds 'no reliable dev server', exit with the graceful degradation recommendation.

### Failure exit
If no candidates are found and the user confirms there's no reliable setup, write a stub `QA-WITNESS.md` at the repo root with this explicit message:
'This project has no reliable dev server configured. qa-witness team will degrade gracefully (only api-witness against pre-running URL, cli-witness, artifact-witness). To enable full visual verification, set up a dev server first then re-run /init-qa-witness.'

This is considered a SUCCESS exit (graceful degradation), not an error.

### Write phase
Write the final `QA-WITNESS.md` at the repo root with the following sections:
- Start Command
- Ready Check
- Seed Strategy
- Teardown Command
- Notes (or 'No Dev Server' alternate template)

Commit suggestion: `chore: initialize qa-witness workflow doc`
