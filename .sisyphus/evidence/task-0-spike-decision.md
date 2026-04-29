# Wave 0 Spike Decisions

## A1: git-guardrails harmonization path
Decision: git-guardrails path: a
Rationale: OMO schema supports `agents.<name>.prompt_append`, so git guardrails can extend agent instructions without disabling the built-in `git-master` skill or forking vendor skill content. OMO also supports custom skills and `disabled_skills`, but prompt append is the least invasive path and matches the existing guidance to layer constraints through prompts.
Artifact: Agent `prompt_append` entries in `opencode/oh-my-openagent.json`

## A2: Skills directory exposure mechanism
Decision: Dotbot directory symlink (opencode/skills/ → ~/.config/opencode/skills/)
Rationale: Consistent with nvim/ precedent in install.conf.yaml. Format: `~/.config/opencode/skills: opencode/skills`
Artifact: install.conf.yaml link entry

## A3: Memory MCP per-agent ACL semantics
Decision: Convention-only enforcement
Rationale: Memory MCP has no native ACL or per-agent authorization model in its README; it only exposes a shared knowledge graph and optional `MEMORY_FILE_PATH` storage location. Access boundaries therefore must be enforced by repository conventions, AGENTS.md rules, and agent prompt constraints.
Artifact: MEMORY-POLICY.md + agent prompt constraints

## A4: Serena --context flag
Decision: --context claude-code
Rationale: Serena docs list `claude-code` as a valid built-in context and show Claude Code setup commands using `serena start-mcp-server --context claude-code --project-from-cwd` for user scope or `serena start-mcp-server --context claude-code --project "$(pwd)"` for project scope. That context is specifically documented to disable duplicate built-in tools for Claude Code.
Env var: MEMORY_FILE_PATH=MEMORY_FILE_PATH
Artifact: opencode/opencode.json MCP entry
