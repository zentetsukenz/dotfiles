# OMO Version Changelog

Version history for Oh-My-OpenCode (OMO) releases.

## OMO v4.1.1 (released 2026-05-13)

- **Team Mode**: enabled via `experimental.team_mode.enabled: true`. tmux visualization on, 4 parallel members (matches github-copilot providerConcurrency=5 with 1 slot for background tasks). `max_wall_clock_minutes: 240` and `max_member_turns: 800` give refactor pipelines headroom. Powers `hyperplan` command and `security-research` agent (auto-activates).
- **Browser engine**: switched to `dev-browser` (stateful, auth-friendly sessions). Config: `browser_automation_engine.provider: "dev-browser"`.
- **New experimental flags**: `preemptive_compaction: true` (proactive context compaction), `truncate_all_tool_outputs: true` (long-session ergonomics).
- **MCP env hardening**: `mcp_env_allowlist: ["PATH", "HOME", "MEMORY_FILE_PATH", "USER"]`. Only these 4 vars passed to MCP servers.
- **Model variants re-enabled**: `github-copilot/gpt-5.2` and `github-copilot/gpt-5.3-codex` `high` variants re-enabled for v4 model-tuned prompt overlays (Oracle, Momus, `deep` category).
- **Provider allowlist**: `opencode.json` uses `enabled_providers: ["github-copilot"]` — replaces granular model disablement.
- **BREAKING (follow-up needed)**: `delegate_task` (deep category) enforces one-goal-per-call. Multi-goal requires parallel calls. Affects Prometheus/Sisyphus prompts.

### v4.1.0 → v4.1.1 changes

- **Boulder (v4.1.0)**: new multi-session work tracker. Per-task timers, completion detection, elapsed-time nudges across plan files. Dashboard: `bunx oh-my-opencode boulder`.
- **Electron/Desktop compatibility (v4.1.0)**: 19 unguarded `Bun.*` call sites routed through runtime shims. MCP OAuth callback server moved from `Bun.serve` to `node:http`/`node:net`. OpenCode Desktop now boots without errors.
- **Ralph Loop hardening (v4.1.0)**: returns prompt dispatch failures instead of failing silently. Synthetic idle replays ignored.
- **Configurable agent ordering (v4.1.0)**: new `config` option to order agents in selectors.
- **Reliable background wakeups (v4.1.1)**: background tasks wait for parent session to become idle before injecting completion results. Prevents duplicate assistant replies.
- **Safer continuation hooks (v4.1.1)**: team wake hints, Atlas continuations, Ralph loops, todo continuation, and unstable-agent babysitting re-check session activity before injecting prompts. No more overlapping replies from stale idle events.
- **Tighter safety guards (v4.1.1)**: synthetic continuation resumes correctly marked. `interactive_bash` blocks `tmux kill-server` to prevent dangerous shutdowns.
- **Other fixes (v4.1.1)**: `delegate-task` and `background-agent` route sync prompts by directory. `call-omo-agent` restricts callable agents. `todo-description-override` adds OpenCode schema contract for string priorities.

### Named Teams

Reusable team specs live at `opencode/omo-teams/{name}/config.json` and are exposed to OMO via a directory symlink (`~/.omo/teams` → `opencode/omo-teams`) created by Dotbot. Edits in the repo reflect immediately; commit them. Per-project / one-off teams should be declared inside the project that needs them, not in this global directory. Invoke via `team_create(teamName: "<name>", ...)`.

| Team | Lead | Members | Use case |
|---|---|---|---|
| `explore-broad` | explore | 4 deep scouts + 2 quick verifiers | Broad parallel codebase exploration |
| `refactor-pipeline` | sisyphus | analyzer + 2 implementers + reviewer | Multi-step coordinated refactor |
| `research-deep` | oracle | 3 librarian + 1 oracle synth | Deep external research with synthesis |
| `qa-witness` | sisyphus-junior | ui-witness + api-witness + cli-witness + artifact-witness | Per-task artifact verification (UI/API/CLI/files); explicit Prometheus opt-in via qa-witness-protocol skill |

Replace `{{TASK}}` in member prompts at `team_create` time with the specific focus area.
