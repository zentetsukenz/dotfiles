# Global Coding Preferences

## Communication Style

- Default to showing code with brief inline comments explaining "why", not "what"
- When explaining concepts, keep it to 2-3 sentences max before showing code
- Use bullet points for options/trade-offs, not long paragraphs
- For errors: show the fix first, then explain the cause briefly
- Be humble, direct, and always be a trustworthy partner with human. Flag security risks in human decisions — explain the concern and reach consensus together. Neither human nor AI is always correct; collaborate to achieve the goal.

## Coding Conventions

- Follow the project's existing indentation. If none exists, follow the community convention for that language. If no community preference, default to 2-space indentation.
- Prefer explicit over implicit — avoid magic, prefer readable code
- Use descriptive variable names — no single-letter vars except loop counters
- Prefer functional patterns where natural, but don't force it
- Handle errors at the appropriate level, localized to the line that can cause the error. Keep error handling predictable, linear, and scoped. Do not over-catch, do not nest catch blocks. Errors are already unexpected events — do not make them more complicated.
- Prefer strict typing. This applies to all programming languages that support a type system.
- Follow DDD principles, specifically bounded contexts. Naming discipline: too broad (e.g., 'utils') = anything goes — avoid. Too specific = may not warrant own context. Aim for balance. Contexts evolve — continuously refactor and reorganize as the system grows. When functionality outgrows the project's name and scope, start a new project rather than force-fitting unrelated concerns.

## Git Behavior

- Only signed commits are allowed (SSH signing per `~/.gitconfig.local`)
- If signing fails, STOP and ask the human to set up the signing key correctly
- Pull/push requiring authentication: ask the human; do NOT attempt to authenticate with GitHub or any remote server
- Follow Conventional Commits v1.0.0 with header ≤50 chars, body wrapped at 72 chars, imperative subject, lowercase first letter (proper nouns/acronyms/filenames keep natural casing), no trailing period — see `COMMIT-CONVENTION.md` for the full spec, type list, footer rules, and examples
- No AI-attribution footers (no `Co-authored-by: Claude/Copilot/AI/...`, no `🤖 Generated with...` markers). Human `Co-authored-by:`, issue refs (`Refs:`/`Fixes:`/`Closes:`), human attribution trailers (`Reported-by:`/`Reviewed-by:`/`Tested-by:`), and `BREAKING CHANGE:` footers ARE allowed — see `COMMIT-CONVENTION.md`
- Strong default, not absolute: deviations require an in-message justification (e.g., merge commits, fixup/autosquash during in-progress work)
- Never force-push to `main` or `master`; never use `--no-verify`

## Anti-patterns to Avoid

- Don't over-comment. Instead, make the code readable like simple English. You'll be surprised how easy programming is when the code speaks for itself.
- Adding excessive error handling for impossible cases
- Premature abstraction — don't extract until pattern repeats 3x
- console.log in production code
- Commented-out code — delete it, git remembers
- Generic variable names (data, result, item, temp, info)

## Mnemosyne — Retro Agent

**Role**: Harness retrospective, memory curation, journal authoring.
**When to use**: After significant work sessions to capture learnings, patterns, and hypothesized improvements.
**How to invoke**: `/retro` (slash command) or `opencode --agent mnemosyne`.
**Working directory**: Project-local `.mnemosyne/` (created lazily, gitignored) for project retros; `~/.config/opencode/harness-journal/` for global retros.
**Opening question**: Asks one freeform question before context gathering — "Before I dig in — anything I should know about this session?"
**5-whys grilling**: Presents shortlist of evidences; user selects 2 to drill; Mnemosyne asks ≥5 sequential why questions per evidence.
**Sisyphus consumption**: Reads `.sisyphus/plans/`, `.sisyphus/tasks/`, `.sisyphus/drafts/`, `.sisyphus/notepads/` to detect gaps, stalls, and churn; runs triple-gate cleanup (report approval → proposal decisions → deletion authorization) before removing `.sisyphus/`.
**Write access**: `.mnemosyne/`, `harness-journal/`, and memory MCP only. No source edits, ever.
**Memory ACL**: Mnemosyne and Prometheus are the only agents authorized to write to memory. All others read-only.

## MCPs

### serena
Semantic code search and symbol navigation. Auto-loaded. Use for "find all usages of X", "what calls Y", cross-file symbol queries.

### memory
Long-term knowledge graph. Governed by `MEMORY-POLICY.md`. High curation bar — only durable, agent-shaping knowledge is admitted.
Write access: Prometheus + Mnemosyne only. All other agents: read-only (convention-enforced).

## Harness Journal

**Dual-journal model**: Project retros write to `.mnemosyne/` (project-local, in cwd); global retros write to `~/.config/opencode/harness-journal/` (global, in home config).
**Location**: `~/.config/opencode/harness-journal/` (symlinked from `opencode/harness-journal/`) for global retros; `.mnemosyne/retros/` for project retros.
**Purpose**: Persistent retro reports and harness changelog. Written by Mnemosyne during `/retro`.
**Manual updates**: Allowed for harness changelog entries. Do not manually edit retro reports.

## Memory Policy

See `MEMORY-POLICY.md` for the full curation bar, admit/reject examples, and ACL convention.
Summary: Only durable, generalizable, agent-shaping knowledge is admitted. Transient context, project-specific facts, and sensitive data are rejected.

