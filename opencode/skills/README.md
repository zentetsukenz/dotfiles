# OpenCode Skills

This directory contains vendored skills from [mattpocock/skills](https://github.com/mattpocock/skills).

## About

Skills are editable copies of upstream implementations, not a Git submodule. This allows for local customization while maintaining attribution to the original source.

## Provenance

See [`LICENSE-attribution.md`](./LICENSE-attribution.md) for:
- Upstream repository and license information
- Provenance table tracking commit SHAs and retrieval dates
- Full license text

## Structure

Each skill is contained in its own directory with a `SKILL.md` file describing its purpose and usage.

## Disable-Model-Invocation Policy

All skills vendored into this directory include `disable-model-invocation: true` in their YAML frontmatter. This prevents OMO from auto-discovering and injecting skills without explicit agent wiring.

Skills are wired explicitly per-agent via the `skills` array in `opencode/oh-my-openagent.json`. No skill is injected globally or by default.

**Current exceptions**: none — all vendored skills use explicit wiring.

## Agent → Skill Map

Sourced from the approved batch artifact (`.omo/notepads/agent-skills-equipping/skill-review-batch.md`) and wiring completed in tasks 6–8.

| Agent | Skills | Notes |
|-------|--------|-------|
| prometheus | domain-model, design-an-interface, triage, qa-witness-protocol, to-prd, to-issues, zoom-out, skill-creator, architect-review | Planning, PRD authoring, architecture review |
| sisyphus | qa-witness-protocol, to-prd, to-issues, tdd, diagnose, prototype, verification-before-completion, systematic-debugging | Primary implementation agent |
| sisyphus-junior | tdd, diagnose, verification-before-completion, systematic-debugging | Focused task executor |
| hephaestus | improve-codebase-architecture, prototype | Architecture improvement and prototyping |
| metis | zoom-out, grill-with-docs | Pre-planning consultation |
| momus | grill-with-docs | Plan critique |
| oracle | architect-review | Read-only architecture review |
| librarian | (none) | No approved candidate fit its role |
| explore | (none) | No approved candidate fit its role |
| atlas | (none) | Orchestrator — no domain skills needed |
| multimodal-looker | (none) | No candidate fit its role today — documented gap |
| mnemosyne | (none — wired via .md prompt) | Skills referenced in agent prompt, not JSON |
