# Memory Policy

## Purpose
Memory shapes agent identity. It isn't just a database. It's the accumulation of experiences that define how an agent perceives and interacts with the world. A bad memory could be a trauma, leading to distorted reasoning or inefficient patterns. Because memory is fundamental to the agent's core, we maintain a very high curation bar to ensure only valuable, constructive, and accurate information is retained.

## Curation Bar
The governing principle for all memory operations is that a bad memory could be a trauma; memory shapes agent. We only admit durable, generalizable, and agent-shaping knowledge. If information doesn't fundamentally improve the agent's ability to reason, decide, or act in future sessions, it doesn't belong in memory.

## What to Admit
We admit durable concepts, agent-shaping reasoning, high-level abstractions, and structural ideas. This knowledge should be applicable across different tasks and projects, providing a foundation for better future performance.

### Admit: The "fail-fast" principle in shell scripting
Recognizing that scripts should exit immediately on error (set -e) is a durable pattern. It shapes how the agent writes all future scripts, ensuring reliability and predictability. This isn't just a project fact; it's a fundamental improvement in how the agent operates.

### Admit: Recognizing that a specific library's documentation is frequently misleading
Identifying a pattern of inaccuracy in a specific source helps the agent approach that source with healthy skepticism. This reasoning generalizes to any task involving that library, preventing the agent from repeating the same mistakes or wasting time on known-bad paths.

### Admit: An abstraction for handling multi-step git operations
Developing a mental model for grouping complex git tasks into atomic, verifiable units is an agent-shaping abstraction. It improves the agent's execution strategy across any repository, moving beyond simple command execution to sophisticated workflow management.

## What to Reject
We reject transient context, project-specific facts that don't generalize, raw tool output, dated information that will soon be irrelevant, and sensitive data. Memory is for wisdom, not for temporary storage.

### Reject: The current line number of a bug in a specific file
This is transient context. Once the file is edited or the bug is fixed, this information becomes useless or, worse, misleading. It doesn't shape the agent's identity; it's just a temporary coordinate that should stay in the session transcript.

### Reject: The exact output of a npm install command
Tool output is voluminous and mostly noise. While the outcome (success or failure) matters for the current task, the raw logs provide no durable knowledge. Storing this would clutter memory with project-specific debris that doesn't help the agent reason about future installations.

### Reject: A temporary API key used for a single integration test
Sensitive data must never enter memory. It's project-specific, transient, and poses a security risk. Memory should focus on how to use APIs securely, not the credentials themselves. Storing this would be a violation of security protocols and a waste of memory space.

## Starter Ontology
We use a structured ontology to categorize knowledge and define relationships.

**Entity types:**
- Agent: An entity that performs tasks and holds memory.
- Skill: A specific capability or expertise.
- Convention: An agreed-upon way of doing things.
- Pattern: A recurring solution to a common problem.
- Pitfall: A common mistake or anti-pattern to avoid.

**Relation types:**
- enhances: One entity improves the effectiveness of another.
- conflicts-with: Two entities cannot or should not coexist.
- supersedes: A newer entity replaces an older one.
- derives-from: One entity is based on or originated from another.

## Revisability Policy
Memory is append-only by default to preserve history and prevent accidental data loss. However, Mnemosyne may revise or supersede existing memories during retrospectives. Any such revision must include explicit reasoning, documenting why the update is necessary and how it improves the agent's knowledge base.

## Multi-Machine Note
Each machine maintains its own memory.json file. Divergence between machines is acceptable and expected, as each environment may provide unique learning opportunities. If global consistency is required, a deliberate retrospective export and manual sync process must be initiated.

## ACL Convention
We enforce memory access control via convention. Technical enforcement is not currently supported by the memory MCP.
- **Write access:** Restricted to prometheus and mnemosyne agents only. These agents are responsible for distilling session experiences into durable memories.
- **Read access:** Available to all agents. Every agent should benefit from the collective wisdom stored in memory.
- **Enforcement:** These rules are documented in AGENTS.md and embedded in the core instructions for each agent to ensure compliance.
