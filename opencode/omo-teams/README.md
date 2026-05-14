# OMO Named Teams

Reusable team specs for Oh-My-OpenCode. Invoke via `team_create(teamName: "<name>", ...)`.

| Team | Lead | Members | Use case |
|---|---|---|---|
| `explore-broad` | explore | 4 deep scouts + 2 quick verifiers | Broad parallel codebase exploration |
| `refactor-pipeline` | sisyphus | analyzer + 2 implementers + reviewer | Multi-step coordinated refactor |
| `research-deep` | oracle | 3 librarian + 1 oracle synth | Deep external research with synthesis |
| `qa-witness` | sisyphus-junior | ui-witness + api-witness + cli-witness + artifact-witness | Per-task artifact verification (UI/API/CLI/files); explicit Prometheus opt-in via qa-witness-protocol skill |

Replace `{{TASK}}` in member prompts at `team_create` time with the specific focus area.
