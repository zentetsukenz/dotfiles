# Task 23 — Auto-invoke Trigger Overlap Audit

## design-an-interface triggers
- Generate multiple radically different interface designs for a module
- User wants to design an API
- Explore interface options
- Compare module shapes
- User mentions "design it twice"

## github-triage triggers
- Triage issues through a state machine driven by triage roles
- User wants to create an issue
- Triage issues
- Review incoming bugs or feature requests
- Prepare issues for an AFK agent
- Manage issue workflow

## Analysis
The two descriptions target different user intents. `design-an-interface` is about generating and comparing API or module interface designs, while `github-triage` is about issue-tracker workflow and state transitions. A prompt that asks to design an API or compare module shapes would not plausibly be read as issue triage, and a prompt about triaging issues or preparing issue workflow would not plausibly be read as interface design. Because the trigger phrases are domain-specific and action-specific, a single prompt is unlikely to auto-invoke both skills.

Verdict: no collision
