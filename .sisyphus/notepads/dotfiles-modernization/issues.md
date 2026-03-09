# Issues — dotfiles-modernization

## [2026-03-09] Known Issues / Gotchas

### brew.sh line 72 bug
- Duplicate concatenated `asdf install elixir` commands on one line — IGNORE this bug, do not port to Brewfile

### fish_config.fish LDFLAGS/CPPFLAGS bug
- Current file overwrites LDFLAGS/CPPFLAGS 3 times (ncurses + PHP blocks) — only last takes effect
- FIXED: removed entirely (PHP deps gone, ncurses not needed for Erlang on modern macOS)

### groad.fish — uses `$argv..HEAD` syntax
- Current groad uses filter-branch with `$argv..HEAD` range (NOT `HEAD` alone)
- Replacement MUST preserve range syntax: `groad HEAD~5` means "last 5 commits"

### First-time install order is CRITICAL
- Homebrew bootstrap → brew bundle → mise install → Fisher bootstrap → fisher update
- Each step depends on the previous completing successfully

### Fisher bootstrap
- `fisher update` needs fisher installed — use curl-bootstrap first:
  `fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"`
- Then: `fish -c "fisher update"` to install plugins from fish_plugins

### Ghostty theme name
- Case-sensitive — must be exactly `Sonokai` (Title Case) if using built-in theme name
- Ghostty bundles iTerm2-Color-Schemes collection

### YAML indentation in install.conf.yaml
- Incorrect indentation breaks everything — YAML errors are often silent in Dotbot
- Validate with: `ruby -ryaml -e "YAML.load_file('install.conf.yaml', permitted_classes: [Symbol])"`

## [2026-03-09] Task 4 observations

### QA gotcha: evidence redirection
- Redirection must apply to the whole QA block when capturing PASS/FAIL lines; otherwise only the final check is written to evidence file.

### Content gotcha: removal check strictness
- Literal mention of removed technology names (e.g., `bobthefish`) in comments will fail strict grep-based removal QA.
