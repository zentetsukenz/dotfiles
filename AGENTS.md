# PROJECT KNOWLEDGE BASE

**Generated:** 2026-04-30
**Commit:** 2067e09
**Branch:** master

## OVERVIEW

Personal macOS (Apple Silicon) development environment managed by **Dotbot** (git submodule). Ghostty terminal, Fish shell, Starship prompt, LazyVim (Neovim), SSH-signed git, multi-language runtimes via mise.

For projects with dev servers, see `QA-WITNESS.md` (generate via `/init-qa-witness`).

## STRUCTURE

```
dotfiles/
├── install                      # Dotbot entrypoint
├── install.conf.yaml            # Symlink + shell command source of truth
├── dotbot/                      # Submodule — DO NOT EDIT
├── fish_config.fish             # Fish shell config
├── fish_plugins                 # Fisher plugin list
├── fish_functions/              # Git aliases + vim→nvim redirect (see fish_functions/README.md)
├── nvim/                        # LazyVim config (init.lua, lua/config/*, lua/plugins/*)
├── ghostty_config               # Terminal config (Sonokai, Hack Nerd Font)
├── tmux.conf                        # tmux config (OSC 52, mouse, vi-mode)
├── starship.toml                # Prompt
├── opencode/                    # OpenCode + OMO: opencode.json, oh-my-openagent.json, AGENTS.md,
│                                #   MEMORY-POLICY.md, skills/, omo-teams/, harness-journal/,
│                                #   agents/, bin/ (memory scripts), commands/
├── .mnemosyne/                  # Project-local retro journal (gitignored): retros/, notes/, proposals/
├── global_gitconfig             # Git config (COPIED to ~/.gitconfig, not symlinked)
├── global_gitignore             # Global gitignore
├── Brewfile                     # Homebrew packages
├── macos/                       # Modular macOS defaults: apply.sh + 8 domain modules + _helpers.sh
├── mise_config.toml             # Language runtime versions
├── scripts/                     # setup_ssh_agent.sh, setup_git_local.sh, check_ssh_agent.sh
└── init_gcloud.sh               # GCP SDK + kubectl init
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Add new dotfile | `install.conf.yaml` → `link:` section | Create file at root, add symlink mapping |
| Add new shell function | `fish_functions/*.fish` + `fish_functions/README.md` | Pattern: `function name --description 'desc'` + `command <tool> $argv`; update alias table |
| Add brew package | `Brewfile` | `brew "pkg"` or `cask "app"`, run `brew bundle` |
| Change macOS defaults | `macos/` | Edit the relevant domain module (`dock.sh`, `finder.sh`, etc.). Run: `DRY_RUN=1 bash macos/<module>.sh` or `sh macos/apply.sh [--dry-run] [--fresh-install]` — requires Full Disk Access + sudo |
| Add language runtime | `mise_config.toml` + `Brewfile` | Add build deps to Brewfile, version to mise_config.toml, run `mise install` |
| Change shell setup | `fish_config.fish` | PATH, env vars, tool init (mise, starship, zoxide) |
| Add install step | `install.conf.yaml` → `shell:` section | Runs sequentially during `./install` |
| Change terminal look | `ghostty_config` | Sonokai theme, Hack Nerd Font 16pt, fullscreen |
| Change prompt | `starship.toml` | Minimal config, many modules disabled |
| Change tmux config | tmux.conf | Symlinked to ~/.config/tmux/tmux.conf via dotbot |
| Change Ghostty clipboard | ghostty_config | OSC 52: clipboard-read/write = allow |
| Change OpenCode/OMO keys | opencode/AGENTS.md | See new keys section for small_model, babysitting, etc. |
| Change editor config | `nvim/lua/config/options.lua` | LazyVim options |
| Add editor plugin | `nvim/lua/plugins/*.lua` | Return plugin spec table |
| Add editor language | `nvim/lua/config/lazy.lua` | `{ import = "lazyvim.plugins.extras.lang.<name>" }` |
| Add editor keymap | `nvim/lua/config/keymaps.lua` | `vim.keymap.set(...)`, leader+l group for LSP |
| Change git config | `global_gitconfig` | NOTE: COPIED by install script, not symlinked |
| Machine-local git overrides | `~/.gitconfig.local` | Created by `scripts/setup_git_local.sh`, SSH signing key path — NOT in repo |
| Change SSH agent config | `scripts/setup_ssh_agent.sh` + `fish_config.fish` | LaunchAgent plist at ~/Library/LaunchAgents/ |
| Diagnose SSH agent | `scripts/check_ssh_agent.sh` | Read-only health check; exit 0=healthy, 1=broken, 2=binary missing |
| Change OpenCode agents/models | `opencode/oh-my-openagent.json` | Symlinked — changes reflect immediately. OMO releases at https://github.com/code-yeongyu/oh-my-openagent/releases |
| Add OpenCode command | `opencode/commands/*.md` | Markdown template with YAML frontmatter — auto-discovered |
| Change global AI preferences | `opencode/AGENTS.md` | Applies to all projects — project AGENTS.md overrides |
| Add/update vendored skill | `opencode/skills/` | YAML frontmatter + body; wire to agent in `opencode/oh-my-openagent.json` |
| Run retro / view journal | `.mnemosyne/retros/` (project) + `~/.config/opencode/harness-journal/` (global) | Dual-journal: project retros in `.mnemosyne/`, global retros in `harness-journal/`. Written by Mnemosyne via `/retro` |
| Change memory policy | `opencode/MEMORY-POLICY.md` | Curation bar, ACL convention |
| Add memory-maintenance script | `opencode/bin/` | Extensionless bash scripts (`opencode/bin/memory-*`), symlinked to `~/.config/opencode/bin/`, on PATH via fish_config; bare-name invocation |
| Add/update memory skills | `opencode/skills/memory-{rot-detect,promote,demote}/` | SKILL.md files for Mnemosyne |
| Add/update OMO team spec | `opencode/omo-teams/{name}/config.json` | Symlinked — edits in the repo reflect immediately. Per-project teams should be defined in the project itself, not here. |
| Initialize QA Witness | Run `/init-qa-witness` | Generates `QA-WITNESS.md` at repo root; may exit with setup recommendation if no dev server |

## CONVENTIONS

- **Flat file naming**: Root-level configs prefixed by tool name (`fish_config.fish`, `ghostty_config`, `starship.toml`)
- **Dotbot manages all symlinks**: Never manually symlink — add to `install.conf.yaml` `link:` section
- **Git config is COPIED not linked**: `cp global_gitconfig ~/.gitconfig` — edits to `~/.gitconfig` won't reflect back
- **Fish functions use `command git`**: Not `git` directly — prevents infinite Fish recursion
- **Fish functions follow 3-line pattern**: `function name --description 'desc'` / `command git subcmd $argv` / `end`
- **Fish is the only interactive shell**: Automation scripts use `#!/usr/bin/env bash`
- **SSH signs all commits**: `gpg.format = ssh` in global_gitconfig, signing key path in ~/.gitconfig.local (per-machine)
- **SSH agent is Homebrew openssh**: macOS built-in ssh-agent disabled — Homebrew version at /opt/homebrew/bin/ssh-agent supports FIDO2/libfido2
- **vim always means nvim**: `fish_functions/vim.fish` redirects, `EDITOR=nvim` in fish_config
- **Extension point**: `fish_config.fish` sources `~/.config/fish/config-extension.fish` if it exists — machine-local overrides
- **Sonokai everywhere**: Ghostty theme, Neovim colorscheme — consistent visual identity
- **Rebase-pull by default**: `pull.rebase = true`, `rebase.autoStash = true` in git config
- **Delta for diffs**: Syntax-highlighted diffs in git, with navigate and line numbers
- **`.mnemosyne/` is project-local and gitignored**: Created lazily by Mnemosyne during `/retro`. Mirrors `.sisyphus/` philosophy — local working state, not committed. Contains `retros/` (reports), `notes/` (grilling), `proposals/` (decisions).
- **QA Witness Workflow Doc** lives at `QA-WITNESS.md` at repo root (per-project, generated by `/init-qa-witness`). AGENTS.md should link to it when present.

## ANTI-PATTERNS

- **DO NOT edit `dotbot/`** — Git submodule, vendor code. Update: `git submodule update --remote dotbot`
- **DO NOT manually symlink** — Use `install.conf.yaml` link section
- **DO NOT add secrets** — No .env, tokens, API keys. Signing key goes in `~/.gitconfig.local` (not in repo)
- **DO NOT use `git` directly in fish functions** — Use `command git` to prevent infinite recursion
- **`groad` rewrites git history** — `rebase --exec` resetting commit dates. Dangerous in shared repos
- **`gdgb` force-deletes branches** — `git branch -D` via pipeline, irreversible without reflog
- **`gphf` ignores arguments** — Hardcoded `push --force-with-lease` with no `$argv` passthrough
- **DO NOT use `gdgb` in shared repos** — `git branch -D` pipeline force-deletes gone branches; irreversible without reflog
- **DO NOT rely on `gphf` for targeted pushes** — hardcodes `git push --force-with-lease` with no `$argv` passthrough; cannot specify remote or branch
- **DO NOT run `groad` on shared branches** — `rebase --exec` rewrites commit dates, rewriting history; dangerous in shared repos
- **DO NOT use macOS built-in ssh-agent for FIDO2** — Apple disabled libfido2 support. Use Homebrew openssh only.
See [`fish_functions/README.md`](fish_functions/README.md) for the full alias table. Scar-driven warnings (`gdgb`, `gphf`, `groad`) are in ANTI-PATTERNS below.
See `README.md` "Fresh Install" section for the full install sequence.

## CROSS-REFERENCES

- **SSH agent chain**: `fish_config.fish` (SSH_AUTH_SOCK) → `scripts/setup_ssh_agent.sh` (LaunchAgent + Homebrew openssh) → `~/Library/LaunchAgents/dev.dotfiles.ssh-agent.plist`. Failure modes (stale socket, KeepAlive loop) and recovery (`launchctl kickstart -k gui/$(id -u)/dev.dotfiles.ssh-agent`) documented in `scripts/check_ssh_agent.sh`.
- **Signing chain**: `global_gitconfig` (gpg.format=ssh, gpgsign=true) → `scripts/setup_git_local.sh` (SSH signing key setup) → `~/.gitconfig.local` (signingKey path)
- **Editor chain**: `fish_config.fish` (EDITOR=nvim) → `global_gitconfig` (core.editor=nvim) → `ghostty_config` (unconsumed Ctrl+hjkl for Neovim, scrollback via $EDITOR)
- **Theme chain**: `ghostty_config` (theme=Sonokai) → `nvim/lua/config/options.lua` (sonokai_style) → `nvim/lua/plugins/colorscheme.lua` (sonokai plugin)
- **OpenCode chain**: `opencode/opencode.json` (plugin config) → `opencode/oh-my-openagent.json` (agents, categories, concurrency, experimental features) → `opencode/AGENTS.md` (global coding rules) → `opencode/commands/` (custom slash commands)
- **memory chain**: `opencode/AGENTS.md` → `MEMORY-POLICY.md` → mnemosyne agent → memory MCP
- **mnemosyne chain**: `.mnemosyne/` (project-local) ← Mnemosyne agent ← `/retro` command. Proposals in `.mnemosyne/proposals/` reviewed individually, archived after decision. Dual-journal: project mode → `.mnemosyne/`, global mode → `harness-journal/`.

## COMMANDS

```bash
./install                              # Full setup (first time or sync)
brew bundle                            # Install/update Homebrew packages
mise install                           # Install language runtimes
git submodule update --remote dotbot   # Update Dotbot submodule
```

## NOTES

- **macOS Apple Silicon only**: Homebrew at `/opt/homebrew/`, no Linux support
- **vim always means nvim**: `fish_functions/vim.fish` redirects, `EDITOR=nvim` in fish_config
- **Sonokai everywhere**: Ghostty theme, Neovim colorscheme — consistent visual identity
- **Rebase-pull by default**: `pull.rebase = true`, `rebase.autoStash = true` in git config
- **Delta for diffs**: Syntax-highlighted diffs in git, with navigate and line numbers
- **tmux**: OSC 52 clipboard passthrough enabled; tmux.conf at repo root, symlinked to ~/.config/tmux/tmux.conf
- **Fisher plugins**: fisher (manager), sponge (clean history of failed commands), fzf (fuzzy finder)
- **OpenCode config**: All OpenCode + OMO configuration in `opencode/` — symlinked individually to `~/.config/opencode/`. Agents: sisyphus/prometheus/metis/oracle use opus/gpt-5.4, explore uses grok-code-fast-1, quick uses haiku, visual/artistry use gemini
- **Global AGENTS.md**: `opencode/AGENTS.md` — universal coding preferences (Communication, Conventions, Git, Anti-patterns). Project-level AGENTS.md overrides global.
- **Custom OpenCode commands**: `opencode/commands/` — `/release-notes` (user-impact changelog), `/explain-plan` (Mermaid plan visualization with wave grouping and status indicators)
- **SSH commit signing**: `gpg.format = ssh` in global_gitconfig. Signing key path in ~/.gitconfig.local (per-machine). Works with git commit, tag, and merge.
- **FIDO2/YubiKey SSH**: Homebrew openssh ssh-agent via LaunchAgent (dev.dotfiles.ssh-agent) — supports ed25519-sk keys. macOS built-in SSH agent disabled. Run `ssh-add -t 86400` to cache key identity for 24h (touch still required per-connection). Run `bash scripts/check_ssh_agent.sh` to diagnose; stale socket recovery: `launchctl kickstart -k gui/$(id -u)/dev.dotfiles.ssh-agent`.
- **Mnemosyne retro flow**: `/retro` command opens with freeform question, then runs 5-whys grilling on selected evidence, then triple-gate cleanup of `.sisyphus/` (proposals reviewed → decisions made → deletions authorized). Produces retro report in `.mnemosyne/retros/` (project) or `harness-journal/` (global).
- **Commit convention**: AI agents and humans follow Conventional Commits v1.0.0. Full spec, type list, footer rules, AI-attribution denylist, and alternatives table live in `opencode/COMMIT-CONVENTION.md` (symlinked to `~/.config/opencode/COMMIT-CONVENTION.md`).
- **Memory maintenance scripts**: `memory-stats`, `memory-serena-stats`, `memory-snapshot`, `memory-restore`, `memory-prune-snapshots`, `memory-proposal-hash` — in `opencode/bin/`, symlinked to `~/.config/opencode/bin/`, on PATH via fish_config. Invoked bare-name.
- **Memory skills**: `memory-rot-detect`, `memory-promote`, `memory-demote` — in `opencode/skills/`, auto-loaded by Mnemosyne during retro memory-health phase.

See [`opencode/omo-teams/README.md`](opencode/omo-teams/README.md) for named teams.

**Note**: Use `/stop-continuation` to kill active ralph_loop or ultrawork sessions.

> **context-mode routing rules**: see system-injected `<context_window_protection>` block in every agent session.
