# Learnings — dotfiles-modernization

## [2026-03-09] Session Start

### Repo State
- Location: `/Users/zentetsuken/workspace/dotfiles`
- Branch: `modernize-dotfile`
- HEAD: `f9a4842`
- Zero implementation tasks completed — starting fresh

### Key Conventions
- Flat-file repo organization: all configs at root, prefixed by tool (e.g., `fish_config.fish`)
- ALL dotfiles managed via Dotbot (`install.conf.yaml`) — never manually symlink
- `global_gitconfig` is COPIED (not symlinked) — `cp global_gitconfig ~/.gitconfig`
- Fish functions use `command git` (never bare `git`) to avoid infinite recursion
- Fish functions pattern: `function name --description 'desc'` + `command <tool> $argv` (2-4 lines)
- Evidence goes in: `.sisyphus/evidence/task-{N}-{scenario-slug}.txt`

### Architecture Decisions (from plan)
- Replacing: ASDF → mise, bobthefish → starship, Alacritty+tmux → Ghostty, vim-plug → LazyVim, brew.sh → Brewfile
- New directories: `nvim/` (LazyVim), `scripts/` (setup helpers)
- GPG signing key moved from `global_gitconfig` to `~/.gitconfig.local` (local machine override)
- `[include] path = ~/.gitconfig.local` pattern for machine-local overrides
- All tool activations MUST use `if command -q <tool>` guards in fish_config

## [2026-03-09] Task 2 — nvim/ LazyVim Structure

### Files Created
- `nvim/init.lua` — single-line entry: `require("config.lazy")`
- `nvim/lua/config/lazy.lua` — lazy.nvim bootstrap + LazyVim + lang extras (elixir, python, ruby, typescript)
- `nvim/lua/config/options.lua` — ported from nvim_init.vim: tabstop=2, shiftwidth=2, expandtab, relativenumber, scrolloff=10, textwidth=80, clipboard=unnamedplus + sonokai globals
- `nvim/lua/config/keymaps.lua` — additive `<leader>l` group (code_action, rename, format, line diagnostic)
- `nvim/lua/plugins/colorscheme.lua` — sonokai plugin + LazyVim colorscheme override

### Settings Ported from nvim_init.vim
- tabstop, shiftwidth, expandtab, shiftround, relativenumber, scrolloff, textwidth, splitbelow, splitright, diffopt+=vertical
- **NOT ported**: vim-plug setup, hardmode plugin, airline, netrw keymaps, leader=comma (LazyVim uses Space)

### Key Pattern
- Sonokai `vim.g` globals MUST be set in `options.lua` (before lazy loads plugins) — not in colorscheme.lua
- `<leader>l` is additive — LazyVim's `<leader>c` code group is untouched
- LazyVim starter pattern: `init.lua` → `lazy.lua` → spec with `{ "LazyVim/LazyVim", import = "lazyvim.plugins" }` first

### Evidence
- `.sisyphus/evidence/task-2-nvim-structure.txt` — 8/8 PASS
- `.sisyphus/evidence/task-2-nvim-extras.txt` — 4/4 PASS
- `.sisyphus/evidence/task-2-nvim-keymaps.txt` — 4/4 PASS

## [2026-03-09] Task 1: Create Brewfile

### Summary
✓ Created declarative Homebrew Bundle (`Brewfile`) at repo root
✓ Ported 35+ packages from imperative `brew.sh`
✓ Organized with 7 section comments
✓ All QA checks passed

### Key Decisions
- **Mise replaces ASDF**: Lighter, faster, declarative (not ported asdf at all)
- **Ghostty replaces Alacritty**: Modern GPU terminal (kept in casks)
- **Excluded**: PHP build deps (bison, re2c, libgd, libiconv, libzip, oniguruma)
- **Excluded**: Language installs (node, python, ruby, erlang via asdf) — mise handles these
- **Kept**: Erlang/Elixir build deps (wxwidgets, libxslt, fop) for kerl_build_docs
- **Syntax**: Pure declarative — no `brew install` commands, no shell scripts

### Packages Ported
**Included (35 total):**
- Core: coreutils, moreutils, findutils, gnu-sed, wget, openssh
- Shell: fish, starship, zoxide
- Editor: neovim, ripgrep, fzf
- Modern CLI: mise, bat, eza, fd, btop, lazygit, git-delta, tlrc, fastfetch
- Dev: autoconf, cmake, openssl, readline, git, git-lfs, tree
- Build: wxwidgets, libxslt, fop
- Security: gnupg, pinentry-mac
- Casks: ghostty, google-cloud-sdk, font-hack-nerd-font

**Explicitly Excluded:**
- ASDF (lines 65-72 from brew.sh)
- Alacritty (line 34 from brew.sh — replaced by ghostty)
- PHP deps (lines 13-18: bison, re2c, libgd, libiconv, libzip, oniguruma)
- Language runtimes (node, python, ruby, elixir)

### Evidence Saved
- `.sisyphus/evidence/task-1-brewfile-contents.txt` — 13 PASS checks
- `.sisyphus/evidence/task-1-brewfile-exclusions.txt` — 5 PASS checks

### Dependencies
- Task 10 will update `install.conf.yaml` to reference `brew bundle install`
- Task 13 will delete `brew.sh` (now obsolete)

## [2026-03-09] Task 4 — fish_config modernization

### Successful Patterns
- Kept `if command -q <tool>` guards for `mise`, `starship`, and `zoxide` to avoid startup breaks when tools are missing.
- Preserved critical one-liners exactly where required (`config-extension` hook, GPG/SSH setup, Google Cloud SDK source pattern).
- Converted FZF environment vars from universal (`set -U`) to global exported (`set -gx`) to avoid cross-machine shell state leakage.
- Added modern aliases behind command guards and limited to 5 alias commands total (`ls`, `tree`, `cat`, `top`, `lg`).
- Maintained runtime init order in file flow: Homebrew path before guarded runtime/prompt/navigation activation.

## [2026-03-09] Task 9 — Polish ghostty_config

### Changes Made
✓ Added `theme = Sonokai` (line 5, after "# Font" comment)
✓ Changed font-family from `Hack` to `Hack Nerd Font` (line 6)
✓ No other settings modified

### Key Observations
- Ghostty theme names are case-sensitive: must be exactly `Sonokai` (Title Case)
- `Hack Nerd Font` is the correct name (cask: `font-hack-nerd-font` in Brewfile)
- Theme line placement: directly after "# Font" comment, before font-family (logical grouping)
- File remains clean: 60 lines, no structural changes

### Evidence
- `.sisyphus/evidence/task-9-ghostty-config.txt` — 2/2 changes verified

## T12: Removed PHP 8.1.3 from .tool-versions
- **Date**: 2026-03-09
- **Change**: Removed `php 8.1.3` line from `.tool-versions`
- **Context**: PHP removed from the stack; no longer needed for ASDF/mise
- **Status**: ✓ Complete
- **Evidence**: `.sisyphus/evidence/task-12-tool-versions.txt`
- **Notes**: 
  - File now contains 5 entries (down from 6)
  - Maintains proper ASDF/mise format
  - All other language versions preserved unchanged
  - Consistent with PHP removal from brew.sh in earlier tasks

## Task T11: Fish Functions Cleanup (2026-03-09)

### Findings

#### gaac.fish Bug Fix
- **Issue**: Line 2 used bare `git add .` instead of `command git add .`
- **Root cause**: Inconsistency with fish function pattern (all git calls must use `command git` prefix)
- **Fix applied**: Changed line 2 to `command git add .`
- **Why this matters**: Bare `git` calls can recurse infinitely if function is named similarly to a git subcommand

#### groad.fish Modernization
- **Old approach**: Used `git filter-branch` with `$argv..HEAD` range
  - Problem: filter-branch is slow, deprecated, dangerous for history rewriting
  - Problem: `$argv..HEAD` syntax is non-standard and confusing
- **New approach**: Uses `git rebase --exec` with single base commit argument
  - Benefit: Safer, faster, more predictable
  - Benefit: Explicit input validation (error if no argument provided)
  - Implementation: `GIT_SEQUENCE_EDITOR=: command git rebase --exec 'git commit --amend --no-edit --date=now' -i $base`
  - User experience: Clearer usage: `groad HEAD~5` vs old implicit range

#### emptytrash.fish Deletion
- **Why deleted**: Uses `sudo rm -rfv` on system directories
  - Dangerous: High privilege + recursive delete
  - Obsolete: Modern macOS has better trash handling
  - Not portable: Uses macOS-specific paths
- **Impact**: No production risk (function rarely used, better via Finder)

### Fish Functions Pattern Standardization
All 17 fish functions now consistently use:
```fish
function <name> --description '<desc>'
    command <tool> $argv
end
```
This prevents infinite recursion and maintains clean separation between function names and tool commands.


## Task 8 — .macos Tahoe Audit (2026-03-09)

### Removed APIs found in .macos
- `com.apple.notificationcenterui` launchctl plist: removed from modern macOS (daemon no longer present)
- `com.apple.rcd` launchctl plist: iTunes/rcd removed; Music.app doesn't use rcd
- `NSGlobalDomain AppleFontSmoothing`: font smoothing API removed in Tahoe
- `com.apple.dashboard mcx-disabled`: Dashboard removed in Catalina (10.15)
- `com.apple.dock dashboard-in-overlay`: Dashboard removed in Catalina (10.15)
- `tmutil disablelocal`: subcommand removed in Sierra (10.12)
- `com.apple.dashboard devmode`: Dashboard removed in Catalina (10.15)

### Application name change
- "System Preferences" renamed to "System Settings" in Ventura (13.x) — osascript `tell application` target must use new name

### New Tahoe API
- `com.apple.WindowManager EnableTiledWindowMargins`: controls edge-to-edge vs. margin tiling in Sequoia/Tahoe window manager

### Comment-out convention used
Prefix broken lines with `# [TAHOE] Removed: ` — preserves original for reference, clearly marks as deprecated, grep-able.

### Pattern
Dashboard-related keys were the most numerous (3 lines) — Dashboard has been dead since Catalina but scripts like mths.be/macos haven't been updated.

## Task 10 — install.conf.yaml modernization (2026-03-09)

### Changes applied
- Added clean targets for migration safety:
  - `~/.config/nvim`
  - `~/.config/alacritty`
- Updated link targets:
  - Added `~/.config/nvim -> nvim` (directory symlink for LazyVim)
  - Added `~/.config/starship.toml -> starship.toml`
  - Removed legacy `alacritty.toml` and `nvim_init.vim` symlink entries
- Replaced shell block with ordered bootstrap sequence preserving Dotbot `command`/`description` mapping style.

### Ordering learnings
- Install flow must be strict for first-run idempotence:
  1) Homebrew bootstrap
  2) `brew bundle`
  3) `mise install`
  4) Fisher bootstrap
  5) `fisher update`
- `scripts/setup_git_local.sh` must run immediately after copying `global_gitconfig` so machine-local signing key include can be configured before later git usage.

### Validation
- Ruby YAML parse passed with no output:
  - `ruby -ryaml -e "YAML.load_file('install.conf.yaml', permitted_classes: [Symbol])"`
- LSP diagnostics for `install.conf.yaml`: clean (no diagnostics).
