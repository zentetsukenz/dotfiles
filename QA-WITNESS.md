# QA Witness Workflow

## Status: No Dev Server

This project has no reliable dev server configured. qa-witness team will degrade gracefully (only api-witness against pre-running URL, cli-witness, artifact-witness). To enable full visual verification, set up a dev server first then re-run /init-qa-witness.

## Available Witnesses (degraded mode)

- **api-witness**: Can verify against a pre-running URL (provide URL manually)
- **cli-witness**: Can verify CLI tools and shell scripts
- **artifact-witness**: Can verify generated files and configs

## Notes

Scanned: package.json, Cargo.toml, Gemfile, mix.exs, go.mod, pyproject.toml, Makefile, docker-compose.yml — none found.
