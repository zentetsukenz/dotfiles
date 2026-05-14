# Fish Function Reference

Critical scar warnings (gdgb, gphf, groad) are duplicated in `../AGENTS.md` ANTI-PATTERNS section.

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
