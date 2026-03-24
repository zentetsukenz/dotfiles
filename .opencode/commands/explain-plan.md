---
description: Visualize a Sisyphus plan as a Mermaid flowchart
agent: sisyphus
---

Read the active plan. If $ARGUMENTS is provided, use it as the plan file path.
Otherwise, read `.sisyphus/boulder.json` to find the active plan path.
If no active plan exists, respond: "No active plan found. Provide a plan path: /explain-plan <path>"

Generate a GitHub-compatible Mermaid flowchart (flowchart TD) that shows:

1. **Every task** as a node — include task number and title
2. **Dependencies** as directed edges between task nodes
3. **Parallel wave grouping** using subgraphs labeled by wave
4. **Status indicators** in each node: ✅ completed, 🔄 in progress, ⬜ pending
5. **Design decisions** as note nodes (different shape) connected to the tasks they affect
6. **What will be implemented** — brief description inside each task node

The goal is FULL VISIBILITY — not a summary. The human reviewing this diagram should be able
to understand the complete plan: what will be built, in what order, what depends on what,
and what key design decisions were made.

Output the Mermaid diagram in a fenced code block (```mermaid).
After the diagram, list any design decisions or constraints that couldn't fit in the visualization.
