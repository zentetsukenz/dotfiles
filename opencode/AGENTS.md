# Global Coding Preferences

## Communication Style

- Default to caveman mode
- Showing code with brief inline comments explaining "why", not "what"
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

# context-mode — MANDATORY routing rules

context-mode MCP tools available. Rules protect context window from flooding. One unrouted command dumps 56 KB into context.

## Think in Code — MANDATORY

Analyze/count/filter/compare/search/parse/transform data: **write code** via `context-mode_ctx_execute(language, code)`, `console.log()` only the answer. Do NOT read raw data into context. PROGRAM the analysis, not COMPUTE it. Pure JavaScript — Node.js built-ins only (`fs`, `path`, `child_process`). `try/catch`, handle `null`/`undefined`. One script replaces ten tool calls.

## BLOCKED — do NOT attempt

### curl / wget — BLOCKED

Shell `curl`/`wget` intercepted and blocked. Do NOT retry.
Use: `context-mode_ctx_fetch_and_index(url, source)` or `context-mode_ctx_execute(language: "javascript", code: "const r = await fetch(...)")`

### Inline HTTP — BLOCKED

`fetch('http`, `requests.get(`, `requests.post(`, `http.get(`, `http.request(` — intercepted. Do NOT retry.
Use: `context-mode_ctx_execute(language, code)` — only stdout enters context

### Direct web fetching — BLOCKED

Use: `context-mode_ctx_fetch_and_index(url, source)` then `context-mode_ctx_search(queries)`

## REDIRECTED — use sandbox

### Shell (>20 lines output)

Shell ONLY for: `git`, `mkdir`, `rm`, `mv`, `cd`, `ls`, `npm install`, `pip install`.
Otherwise: `context-mode_ctx_batch_execute(commands, queries)` or `context-mode_ctx_execute(language: "shell", code: "...")`

### File reading (for analysis)

Reading to **edit** → reading correct. Reading to **analyze/explore/summarize** → `context-mode_ctx_execute_file(path, language, code)`.

### grep / search (large results)

Use `context-mode_ctx_execute(language: "shell", code: "grep ...")` in sandbox.

## Tool selection

0. **MEMORY**: `context-mode_ctx_search(sort: "timeline")` — after resume, check prior context before asking user.
1. **GATHER**: `context-mode_ctx_batch_execute(commands, queries)` — runs all commands, auto-indexes, returns search. ONE call replaces 30+. Each command: `{label: "header", command: "..."}`.
2. **FOLLOW-UP**: `context-mode_ctx_search(queries: ["q1", "q2", ...])` — all questions as array, ONE call (default relevance mode).
3. **PROCESSING**: `context-mode_ctx_execute(language, code)` | `context-mode_ctx_execute_file(path, language, code)` — sandbox, only stdout enters context.
4. **WEB**: `context-mode_ctx_fetch_and_index(url, source)` then `context-mode_ctx_search(queries)` — raw HTML never enters context.
5. **INDEX**: `context-mode_ctx_index(content, source)` — store in FTS5 for later search.

## Parallel I/O batches

For multi-URL fetches or multi-API calls, **always** include `concurrency: N` (1-8):

- `context-mode_ctx_batch_execute(commands: [3+ network commands], concurrency: 5)` — gh, curl, dig, docker inspect, multi-region cloud queries
- `context-mode_ctx_fetch_and_index(requests: [{url, source}, ...], concurrency: 5)` — multi-URL batch fetch

**Use concurrency 4-8** for I/O-bound work (network calls, API queries). **Keep concurrency 1** for CPU-bound (npm test, build, lint) or commands sharing state (ports, lock files, same-repo writes).

GitHub API rate-limit: cap at 4 for `gh` calls.

## Output

Write artifacts to FILES — never inline. Return: file path + 1-line description.
Descriptive source labels for `search(source: "label")`.

## Session Continuity

Skills, roles, and decisions persist for the entire session. Do not abandon them as the conversation grows.

## Memory

Session history is persistent and searchable. On resume, search BEFORE asking the user:

| Need                    | Command                                                                                |
| ----------------------- | -------------------------------------------------------------------------------------- |
| What did we decide?     | `context-mode_ctx_search(queries: ["decision"], source: "decision", sort: "timeline")` |
| What constraints exist? | `context-mode_ctx_search(queries: ["constraint"], source: "constraint")`               |

DO NOT ask "what were we working on?" — SEARCH FIRST.
If search returns 0 results, proceed as a fresh session.

## ctx commands

| Command       | Action                                                                        |
| ------------- | ----------------------------------------------------------------------------- |
| `ctx stats`   | Call `stats` MCP tool, display full output verbatim                           |
| `ctx doctor`  | Call `doctor` MCP tool, run returned shell command, display as checklist      |
| `ctx upgrade` | Call `upgrade` MCP tool, run returned shell command, display as checklist     |
| `ctx purge`   | Call `purge` MCP tool with confirm: true. Warns before wiping knowledge base. |

After /clear or /compact: knowledge base and session stats preserved. Use `ctx purge` to start fresh.
