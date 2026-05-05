# Commit Convention

Authoritative spec for AI agents and humans working in this repository.
This is the strong default; deviation requires explicit justification.

## TL;DR

- Format: `type(scope): subject` — subject in imperative mood, lowercase first letter, no trailing period.
- Header line ≤ 50 characters; body lines wrap at 72; blank line between header, body, and footer block.
- Footer trailers are an explicit allowlist (Refs, Fixes, Closes, Co-authored-by for humans, BREAKING CHANGE).
- Denylist: no AI attribution. No `Co-authored-by: Claude`, no `🤖 Generated with`, no model identifiers anywhere.

## Format

```
<header>
<BLANK LINE>
<body?>
<BLANK LINE>
<footer-block?>

<header>       ::= <type>("(" <scope> ")")? ": " <subject>
<type>         ::= feat | fix | docs | style | refactor | perf | test | build | ci | chore | revert
<scope>        ::= kebab-case-token  ; free-form, optional
<subject>      ::= imperative, lowercase first letter, no trailing period
<body>         ::= prose, lines wrapped at 72 chars, may be multi-paragraph
<footer-block> ::= one or more <trailer> lines, contiguous, no blank lines between
<trailer>      ::= <token> ": " <value> | "BREAKING CHANGE: " <value>
```

## Types

| Type | When to use | Example subject |
|---|---|---|
| feat | A new user-visible feature or capability | `feat(fish): add gco function for git checkout` |
| fix | A bug fix | `fix(nvim): correct sonokai colorscheme load order` |
| docs | Documentation only | `docs: clarify ssh agent recovery in AGENTS.md` |
| style | Formatting, whitespace, no behaviour change | `style(macos): align indentation in dock.sh` |
| refactor | Internal restructuring, no behaviour change | `refactor(macos): split apply.sh into per-domain modules` |
| perf | Performance improvement | `perf(fish): cache mise activation output` |
| test | Adding or correcting tests | `test(macos): cover dry-run path in apply.sh` |
| build | Build system, package manifests, dependencies | `build(brew): pin ghostty to latest cask` |
| ci | CI configuration only | `ci: add macos runner for shellcheck` |
| chore | Routine maintenance, no production impact | `chore: bump dotbot submodule` |
| revert | Reverts a previous commit | `revert: add experimental fish prompt theme` |

## Scope

Scope is free-form, optional, and kebab-case. There is no canonical list. Pick the
most specific module touched, e.g. `fish`, `nvim`, `opencode`, `macos`, `brew`,
`mise`, `ssh`, `git`. Omit scope when the change is repo-wide.

## Subject mechanics

- Imperative mood: write `add foo`, not `added foo` or `adds foo`.
- Lowercase first letter: `add foo`, not `Add foo`. Proper nouns, acronyms, and
  filenames keep their natural casing mid-subject (e.g. `docs: clarify SSH agent
  recovery in AGENTS.md` is valid).
- No trailing period.
- Full header line — including type, scope, colon, and subject — must be ≤ 50
  characters. If it does not fit, shorten the subject or omit the scope.

## Body

The body is optional but recommended for any non-trivial change. Explain *why*
the change is necessary and what trade-offs were made — not *what* changed; the
diff already says that. Wrap lines at 72 characters. Separate from the header
with a single blank line. Multiple paragraphs are allowed; separate paragraphs
with a single blank line.

## Footer trailers

Trailers form a contiguous block at the end of the message, separated from the
body by a single blank line. No blank lines between trailers.

Allowlist:

- `Refs: #<issue>` / `Fixes: #<issue>` / `Closes: #<issue>` — issue linking.
- `Co-authored-by: <Real Name> <email@example.com>` — humans only.
- `Reported-by: <Real Name> <email>` / `Reviewed-by:` / `Tested-by:` — humans only.
- `BREAKING CHANGE: <description of break>` — for breaking changes.

Conventions:

- **Order**: refs/fixes first, then human attribution, then `BREAKING CHANGE` last.
- **Casing**: keep the capitalised key exactly as shown — `git interpret-trailers`
  is case-sensitive. The separator is `: ` (colon + space).
- **Multiple Refs**: prefer separate lines over comma-joined values.

## Denylist (AI attribution forbidden)

The following MUST NOT appear in any commit message:

- `Co-authored-by: Claude <noreply@anthropic.com>`
- `Co-authored-by: GitHub Copilot <copilot@github.com>`
- `Co-authored-by: <any AI/model name>`
- `🤖 Generated with Claude Code`
- Any line containing `Generated with`, `Powered by AI`, `AI-Assisted`, or model
  identifiers (Claude, GPT, Gemini, Llama, Copilot, etc.)

This is non-negotiable. AI agents do not get attribution.

## Breaking changes

Use the `BREAKING CHANGE: <desc>` footer. Do **not** use the `!` suffix syntax.

```
feat(opencode): rename agent profile keys

BREAKING CHANGE: agent config keys renamed; users must migrate
oh-my-openagent.json
```

## Reverts

Use the Conventional Commits spec form, not git's default `Revert "<subject>"`:

```
revert: add experimental fish prompt theme

This reverts commit abc123def.
```

## Special cases

- **Merge commits**: `pull.rebase = true` is set globally, so merges are rare. If
  one occurs, the default `Merge branch '<x>'` message is acceptable as a
  documented exception (not CC-compliant by design).
- **Fixup / autosquash**: `fixup!` and `squash!` prefixes are allowed during
  in-progress work. They MUST be absorbed via `git rebase --autosquash` before
  the branch is finalised.
- **Initial commit**: the canonical form is `chore: initial commit`.

## Examples (good)

```
feat(fish): add gco function for git checkout
```

```
fix(nvim): correct sonokai colorscheme load order
```

```
docs: clarify ssh agent recovery in AGENTS.md
```

```
refactor(macos): split apply.sh into per-domain modules
```

```
feat(opencode): rename agent profile keys

BREAKING CHANGE: agent config keys renamed; users must migrate
oh-my-openagent.json
```

```
revert: add experimental fish prompt theme

This reverts commit abc123def.
```

## Examples (bad)

| Commit | Why it is bad |
|---|---|
| `Added new feature.` | Past tense, capitalised, trailing period, no type. |
| `feat: Add new feature.` | Capitalised first letter, trailing period. |
| `feat(opencode): refactored the entire agent dispatch pipeline to support concurrency` | Header exceeds 50 characters; verb is past tense. |
| `feat: x` + footer `Co-authored-by: Claude <noreply@anthropic.com>` | AI attribution is banned. |
| `feat!: drop legacy api` | `!` suffix is banned; use the `BREAKING CHANGE` footer instead. |

## What commitlint does NOT enforce

A linter only catches structural violations. The following remain the author's
responsibility (and are checked by the rules in `AGENTS.md`):

- Imperative mood — there is no machine-checkable regex for verb mood.
- "Why not what" body content — semantics, not syntax.
- Scope appropriateness — scope is free-form, so anything passes the lint.
- Whether the commit content actually matches the declared type.

Therefore the prompt rules in `AGENTS.md` and this document are the authority.
commitlint catches structural violations only.

## commitlint usage (advisory)

```bash
# Validate the most recent in-progress commit message:
npx --yes --package=@commitlint/cli commitlint --edit .git/COMMIT_EDITMSG

# Validate the last commit:
npx --yes --package=@commitlint/cli commitlint --from=HEAD~1 --to=HEAD

# Validate a piped message:
echo "feat: example" | npx --yes --package=@commitlint/cli commitlint
```

Requires Node (this repo provides Node 24.12.0 via mise). `npx --yes` fetches
commitlint on demand; no `package.json` is committed to the repo.

## Alternatives considered

| Convention | Summary | Why not chosen |
|---|---|---|
| Conventional Commits v1.0.0 | `type(scope): subject`; machine-readable grammar | **Chosen** — industry standard, drives tooling, AI-friendly grammar |
| Angular | CC parent; 100-char limit, mandatory body | Too verbose for a personal repo |
| Gitmoji | Emoji prefix (🐛 ✨) for commit type | Subjective; awkward to type; weak machine grammar |
| Karma | CC variant emphasising "why" in body | Effectively a stricter CC; no added value here |
| 50/72 classic (Linux/Git) | Imperative subject ≤50, body wrap 72 | No machine-readable type; cannot drive tooling |
| Beams' 7 rules | Humanistic guidance, imperative, capitalise subject | Purely human-centric; lacks structured metadata |

## Rationale

Conventional Commits gives this repo a deterministic grammar that AI agents can
both produce and validate. The advisory linter doubles as living documentation:
when an agent gets it wrong, the failure points back here. The choice also
future-proofs the repo for changelog automation if it is ever wanted, without
requiring it today.

## Evolution policy

This document is the source of truth. AI agents reading `AGENTS.md` are pointed
here for the full rules. Changes to types, footers, or rules are made HERE
first; `AGENTS.md` is then updated to match. If `AGENTS.md` and this document
disagree, this document wins until `AGENTS.md` is corrected.
