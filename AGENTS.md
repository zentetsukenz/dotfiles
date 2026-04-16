# PROJECT KNOWLEDGE BASE

**Generated:** 2026-03-11
**Commit:** 2067e09
**Branch:** master

## OVERVIEW

Personal macOS (Apple Silicon) development environment managed by **Dotbot** (git submodule). Ghostty terminal, Fish shell, Starship prompt, LazyVim (Neovim), SSH-signed git, multi-language runtimes via mise.

## STRUCTURE

```
dotfiles/
├── install                    # Entrypoint — runs Dotbot with install.conf.yaml
├── install.conf.yaml          # Source of truth: symlinks, shell commands, cleanup
├── dotbot/                    # Dotbot submodule (DO NOT EDIT)
│
├── fish_config.fish           # Fish shell → ~/.config/fish/config.fish
├── fish_plugins               # Fisher plugins: fisher, sponge, fzf
├── fish_functions/            # 16 Fish functions → ~/.config/fish/functions/
│   ├── g*.fish (14)           # Git aliases (g, ga, gaa, gaac, gc, gco, gd, gdgb, gfap, gl, gph, gphf, gpl, groad, gs)
│   └── vim.fish              # vim → nvim redirect
│
├── nvim/                      # LazyVim config → ~/.config/nvim/ (directory symlink)
│   ├── init.lua               # Entry: require("config.lazy")
│   ├── lua/config/lazy.lua    # Plugin manager + language extras (Elixir, Python, Ruby, TS)
│   ├── lua/config/options.lua # Sonokai theme, 2-space tabs, relative numbers, clipboard
│   ├── lua/config/keymaps.lua # Spacemacs-style leader+l for LSP actions
│   └── lua/plugins/colorscheme.lua  # Sonokai colorscheme setup
│
├── ghostty_config             # Ghostty terminal → ~/.config/ghostty/config
├── starship.toml              # Starship prompt → ~/.config/starship.toml
├── opencode/                  # OpenCode + OMO configuration
│   ├── opencode.json          # OpenCode plugin config → ~/.config/opencode/opencode.json
│   ├── oh-my-openagent.json   # OMO agents, categories, concurrency, experimental → ~/.config/opencode/oh-my-openagent.json
│   ├── AGENTS.md              # Global coding preferences → ~/.config/opencode/AGENTS.md
│   └── commands/              # Custom command templates (auto-discovered by OpenCode)
│       ├── release-notes.md   # /release-notes — user-facing changelog from git history
│       └── explain-plan.md    # /explain-plan — Mermaid flowchart of active Sisyphus plan
│
├── global_gitconfig           # Git config (COPIED, not linked) → ~/.gitconfig
├── global_gitignore           # Git ignore → ~/.gitignore_global
│
├── Brewfile                   # Declarative Homebrew packages (brew bundle)
├── macos/                     # Modular macOS defaults
│   ├── _helpers.sh            # Shared helper library (set_default, set_plistbuddy, log helpers)
│   ├── apply.sh               # Orchestrator — runs all modules, sudo keepalive, killall sweep
│   ├── dock.sh                # Dock, Mission Control, hot corners
│   ├── finder.sh              # Finder, Desktop, file extension behaviour
│   ├── keyboard.sh            # Keyboard, trackpad, input settings
│   ├── screen.sh              # Screenshots, display, energy saver
│   ├── spotlight.sh           # Spotlight search categories and privacy
│   ├── locale.sh              # Language, region, timezone
│   ├── software_update.sh     # App Store and software update settings
│   └── general_ux.sh          # General UX, sounds, tiling, scroll behaviour
├── mise_config.toml            # mise global config → ~/.config/mise/config.toml
├── scripts/setup_ssh_agent.sh # Homebrew SSH agent LaunchAgent setup (FIDO2/YubiKey)
├── init_gcloud.sh             # GCP SDK + kubectl init (interactive)
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Add new dotfile | `install.conf.yaml` → `link:` section | Create file at root, add symlink mapping |
| Add new shell function | `fish_functions/*.fish` | Pattern: `function name --description 'desc'` + `command <tool> $argv` |
| Add brew package | `Brewfile` | `brew "pkg"` or `cask "app"`, run `brew bundle` |
| Change macOS defaults | `macos/` | Edit the relevant domain module (`dock.sh`, `finder.sh`, etc.). Run: `DRY_RUN=1 bash macos/<module>.sh` or `sh macos/apply.sh [--dry-run] [--fresh-install]` — requires Full Disk Access + sudo |
| Add language runtime | `mise_config.toml` + `Brewfile` | Add build deps to Brewfile, version to mise_config.toml, run `mise install` |
| Change shell setup | `fish_config.fish` | PATH, env vars, tool init (mise, starship, zoxide) |
| Add install step | `install.conf.yaml` → `shell:` section | Runs sequentially during `./install` |
| Change terminal look | `ghostty_config` | Sonokai theme, Hack Nerd Font 16pt, fullscreen |
| Change prompt | `starship.toml` | Minimal config, many modules disabled |
| Change editor config | `nvim/lua/config/options.lua` | LazyVim options |
| Add editor plugin | `nvim/lua/plugins/*.lua` | Return plugin spec table |
| Add editor language | `nvim/lua/config/lazy.lua` | `{ import = "lazyvim.plugins.extras.lang.<name>" }` |
| Add editor keymap | `nvim/lua/config/keymaps.lua` | `vim.keymap.set(...)`, leader+l group for LSP |
| Change git config | `global_gitconfig` | NOTE: COPIED by install script, not symlinked |
| Machine-local git overrides | `~/.gitconfig.local` | Created by `scripts/setup_git_local.sh`, SSH signing key path — NOT in repo |
| Change SSH agent config | `scripts/setup_ssh_agent.sh` + `fish_config.fish` | LaunchAgent plist at ~/Library/LaunchAgents/ |
| Change OpenCode agents/models | `opencode/oh-my-openagent.json` | Symlinked — changes reflect immediately |
| Add OpenCode command | `opencode/commands/*.md` | Markdown template with YAML frontmatter — auto-discovered |
| Change global AI preferences | `opencode/AGENTS.md` | Applies to all projects — project AGENTS.md overrides |

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

## ANTI-PATTERNS

- **DO NOT edit `dotbot/`** — Git submodule, vendor code. Update: `git submodule update --remote dotbot`
- **DO NOT manually symlink** — Use `install.conf.yaml` link section
- **DO NOT add secrets** — No .env, tokens, API keys. Signing key goes in `~/.gitconfig.local` (not in repo)
- **DO NOT use `git` directly in fish functions** — Use `command git` to prevent infinite recursion
- **`groad` rewrites git history** — `rebase --exec` resetting commit dates. Dangerous in shared repos
- **`gdgb` force-deletes branches** — `git branch -D` via pipeline, irreversible without reflog
- **`gphf` ignores arguments** — Hardcoded `push --force-with-lease` with no `$argv` passthrough
- **DO NOT use macOS built-in ssh-agent for FIDO2** — Apple disabled libfido2 support. Use Homebrew openssh only.

## FISH FUNCTIONS REFERENCE

| Function | Wraps | Notes |
|----------|-------|-------|
| `g` | `git $argv` | Base git alias |
| `ga` | `git add $argv` | |
| `gaa` | `git add . $argv` | Adds all |
| `gaac` | `git add .` + `git commit $argv` | Composite — only commit gets $argv |
| `gc` | `git commit $argv` | |
| `gco` | `git checkout $argv` | |
| `gd` | `git diff $argv` | |
| `gdgb` | Pipeline: branch -vv → grep gone → branch -D | ⚠️ Force deletes gone branches |
| `gfap` | `git fetch --all --prune $argv` | |
| `gl` | `git log $argv` | |
| `gph` | `git push $argv` | |
| `gphf` | `git push --force-with-lease` | ⚠️ No $argv — can't specify remote/branch |
| `gpl` | `git pull $argv` | |
| `groad` | `rebase --exec 'commit --amend --date=now'` | ⚠️ Rewrites history — dangerous |
| `gs` | `git status $argv` | |
| `vim` | `nvim $argv` | Editor redirect |

## INSTALL FLOW

```
./install
  ├── Phase 1: Clean stale symlinks (~/  ~/.config  ~/.config/nvim)
  ├── Phase 2: Create symlinks (all configs → home directory, including opencode/ individual file symlinks)
  └── Phase 3: Shell commands (sequential, stops on error)
       1. sh macos/apply.sh                    # macOS defaults (sudo, Full Disk Access)
       2. cp global_gitconfig ~/.gitconfig   # Copy git config (not symlink!)
       3. sh scripts/setup_git_local.sh      # Interactive: SSH signing key → ~/.gitconfig.local
       4. Homebrew bootstrap                 # Install Homebrew if missing
       5. brew bundle --file=Brewfile        # Install all packages + Homebrew openssh
       6. sh scripts/setup_ssh_agent.sh     # Homebrew SSH agent + disable built-in + FIDO2
       7. Fisher bootstrap                   # Install Fisher plugin manager
       8. fisher update                      # Install Fish plugins from fish_plugins
       9. sh init_gcloud.sh                  # Interactive: GCP SDK init
      10. git submodule sync --recursive     # Sync submodule URLs

```

## CROSS-REFERENCES

- **SSH agent chain**: `fish_config.fish` (SSH_AUTH_SOCK) → `scripts/setup_ssh_agent.sh` (LaunchAgent + Homebrew openssh) → `~/Library/LaunchAgents/dev.dotfiles.ssh-agent.plist` (persistent agent)
- **Signing chain**: `global_gitconfig` (gpg.format=ssh, gpgsign=true) → `scripts/setup_git_local.sh` (SSH signing key setup) → `~/.gitconfig.local` (signingKey path)
- **Editor chain**: `fish_config.fish` (EDITOR=nvim) → `global_gitconfig` (core.editor=nvim) → `ghostty_config` (unconsumed Ctrl+hjkl for Neovim, scrollback via $EDITOR)
- **Theme chain**: `ghostty_config` (theme=Sonokai) → `nvim/lua/config/options.lua` (sonokai_style) → `nvim/lua/plugins/colorscheme.lua` (sonokai plugin)
- **OpenCode chain**: `opencode/opencode.json` (plugin config) → `opencode/oh-my-openagent.json` (agents, categories, concurrency, experimental features) → `opencode/AGENTS.md` (global coding rules) → `opencode/commands/` (custom slash commands)

## COMMANDS

```bash
./install                              # Full setup (first time or sync)
brew bundle                            # Install/update Homebrew packages
mise install                           # Install language runtimes
git submodule update --remote dotbot   # Update Dotbot submodule
```

## NOTES

- **macOS Apple Silicon only**: Homebrew at `/opt/homebrew/`, no Linux support
- **Ghostty is primary terminal**: Launches fish, fullscreen, Sonokai theme, Hack Nerd Font 16pt
- **Ghostty quick terminal**: `Cmd+`` toggles dropdown terminal from anywhere (replaces macOS window cycling)
- **Ghostty splits**: `Cmd+D` / `Cmd+Shift+D` for horizontal/vertical, vim-style Ctrl+hjkl navigation
- **LazyVim extras**: Elixir, Python, Ruby, TypeScript language support enabled
- **LSP keymaps**: `<leader>l` group (a=code action, r=rename, f=format, d=diagnostic) alongside LazyVim's `<leader>c`
- **Runtime versions**: Erlang latest, Elixir latest, Node 24.12.0, Python 3.12.11, Ruby 3.1.3
- **Modern CLI aliases**: `ls`→eza, `cat`→bat, `top`→btop, `lg`→lazygit (conditional on install in fish_config)
- **Fisher plugins**: fisher (manager), sponge (clean history of failed commands), fzf (fuzzy finder)
- **OpenCode config**: All OpenCode + OMO configuration in `opencode/` — symlinked individually to `~/.config/opencode/`. Agents: sisyphus/prometheus/metis/oracle use opus/gpt-5.4, explore uses grok-code-fast-1, quick uses haiku, visual/artistry use gemini
- **Global AGENTS.md**: `opencode/AGENTS.md` — universal coding preferences (Communication, Conventions, Git, Anti-patterns). Project-level AGENTS.md overrides global.
- **Custom OpenCode commands**: `opencode/commands/` — `/release-notes` (user-impact changelog), `/explain-plan` (Mermaid plan visualization with wave grouping and status indicators)
- **Podman uses libkrun**: Set via `CONTAINERS_MACHINE_PROVIDER` in fish_config
- **pnpm on PATH**: `~/.pnpm` added in fish_config
- **Erlang build**: Docs enabled (`KERL_BUILD_DOCS=yes`), JIT disabled (`--disable-jit`)
- **Python venvs**: In-project (`PIPENV_VENV_IN_PROJECT=1`)
- **SSH commit signing**: `gpg.format = ssh` in global_gitconfig. Signing key path in ~/.gitconfig.local (per-machine). Works with git commit, tag, and merge.
- **FIDO2/YubiKey SSH**: Homebrew openssh ssh-agent via LaunchAgent (dev.dotfiles.ssh-agent) — supports ed25519-sk keys. macOS built-in SSH agent disabled. Run `ssh-add -t 86400` to cache key identity for 24h (touch still required per-connection)

# context-mode — MANDATORY routing rules

You have context-mode MCP tools available. These rules are NOT optional — they protect your context window from flooding. A single unrouted command can dump 56 KB into context and waste the entire session.

## BLOCKED commands — do NOT attempt these

### curl / wget — BLOCKED
Any shell command containing `curl` or `wget` will be intercepted and blocked by the context-mode plugin. Do NOT retry.
Instead use:
- `context-mode_ctx_fetch_and_index(url, source)` to fetch and index web pages
- `context-mode_ctx_execute(language: "javascript", code: "const r = await fetch(...)")` to run HTTP calls in sandbox

### Inline HTTP — BLOCKED
Any shell command containing `fetch('http`, `requests.get(`, `requests.post(`, `http.get(`, or `http.request(` will be intercepted and blocked. Do NOT retry with shell.
Instead use:
- `context-mode_ctx_execute(language, code)` to run HTTP calls in sandbox — only stdout enters context

### Direct web fetching — BLOCKED
Do NOT use any direct URL fetching tool. Use the sandbox equivalent.
Instead use:
- `context-mode_ctx_fetch_and_index(url, source)` then `context-mode_ctx_search(queries)` to query the indexed content

## REDIRECTED tools — use sandbox equivalents

### Shell (>20 lines output)
Shell is ONLY for: `git`, `mkdir`, `rm`, `mv`, `cd`, `ls`, `npm install`, `pip install`, and other short-output commands.
For everything else, use:
- `context-mode_ctx_batch_execute(commands, queries)` — run multiple commands + search in ONE call
- `context-mode_ctx_execute(language: "shell", code: "...")` — run in sandbox, only stdout enters context

### File reading (for analysis)
If you are reading a file to **edit** it → reading is correct (edit needs content in context).
If you are reading to **analyze, explore, or summarize** → use `context-mode_ctx_execute_file(path, language, code)` instead. Only your printed summary enters context.

### grep / search (large results)
Search results can flood context. Use `context-mode_ctx_execute(language: "shell", code: "grep ...")` to run searches in sandbox. Only your printed summary enters context.

## Tool selection hierarchy

1. **GATHER**: `context-mode_ctx_batch_execute(commands, queries)` — Primary tool. Runs all commands, auto-indexes output, returns search results. ONE call replaces 30+ individual calls.
2. **FOLLOW-UP**: `context-mode_ctx_search(queries: ["q1", "q2", ...])` — Query indexed content. Pass ALL questions as array in ONE call.
3. **PROCESSING**: `context-mode_ctx_execute(language, code)` | `context-mode_ctx_execute_file(path, language, code)` — Sandbox execution. Only stdout enters context.
4. **WEB**: `context-mode_ctx_fetch_and_index(url, source)` then `context-mode_ctx_search(queries)` — Fetch, chunk, index, query. Raw HTML never enters context.
5. **INDEX**: `context-mode_ctx_index(content, source)` — Store content in FTS5 knowledge base for later search.

## Output constraints

- Keep responses under 500 words.
- Write artifacts (code, configs, PRDs) to FILES — never return them as inline text. Return only: file path + 1-line description.
- When indexing content, use descriptive source labels so others can `search(source: "label")` later.

## ctx commands

| Command | Action |
|---------|--------|
| `ctx stats` | Call the `stats` MCP tool and display the full output verbatim |
| `ctx doctor` | Call the `doctor` MCP tool, run the returned shell command, display as checklist |
| `ctx upgrade` | Call the `upgrade` MCP tool, run the returned shell command, display as checklist |
