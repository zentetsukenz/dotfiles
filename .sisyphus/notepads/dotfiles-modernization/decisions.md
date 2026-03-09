# Decisions — dotfiles-modernization

## [2026-03-09] Plan Execution Decisions

### Wave Commit Strategy
- Wave 1: `feat(core): add Brewfile, LazyVim, starship, and modernize fish/git configs`
- Wave 2: `feat(polish): audit macos defaults for Tahoe, polish ghostty, update install config and fish functions`
- Wave 3: `chore(cleanup): remove deprecated alacritty, tmux, vim-plug, and brew.sh files`
- Final: `chore(verify): add QA evidence`

### Task 13 (delete deprecated files) MUST come AFTER Task 10 (install.conf.yaml)
- Deleting before updating install.conf.yaml → Dotbot fails with missing symlink targets

### Task 2 (nvim/) symlinks ENTIRE directory, not individual files
- LazyVim requires this for plugin system compatibility

### Sonokai theme
- Variant: `default` (user can change `vim.g.sonokai_style` later)
- 6 variants available: default, atlantis, andromeda, shusia, maia, espresso

## [2026-03-09] Task 4 — fish runtime modernization decision

- Chose dynamic variable-name construction for stale k8s theme cleanup (`string join`) to avoid literal `theme_display_k8s*` identifiers while still removing old universal vars when present.
- Kept critical extension hook exactly intact and placed under `# === Extensions ===` section to match target organization.
