---
name: agent-orchestration-patterns
description: >
  Provides proven patterns for coordinating multiple AI agents to solve complex
  tasks, including resource budgeting, error handling, and anti-pattern avoidance.
  Use when designing multi-agent workflows, coordinating parallel agent tasks,
  managing shared state between agents, or troubleshooting agent coordination
  failures such as infinite delegation, context explosion, or circular dependencies.
---

# Agent Orchestration Patterns

A comprehensive pattern library for multi-agent coordination. This skill provides
five core orchestration patterns with decision criteria, implementation guidance,
anti-pattern detection, and concrete examples. Each pattern is battle-tested for
AI agent systems where agents have limited context windows, consume tokens, and
can fail unpredictably.

## Instructions

### Core Concept: Why Orchestration Matters

A single agent hitting a complex problem will either:
- Exceed its context window trying to hold everything
- Produce shallow work by rushing through sub-tasks
- Lose coherence as it switches between disparate concerns

Multi-agent orchestration solves this by **decomposing work across specialized
agents**, each operating in a focused context. But orchestration done wrong is
worse than a single agent — it adds latency, cost, and failure modes.

The skill of orchestration is knowing **which pattern to use, when to use it,
and how to avoid the traps**.

---

### Pattern 1: Fork-Join (Parallel Decomposition)

**Structure:**
```
            ┌── Agent A (subtask 1) ──┐
Orchestrator├── Agent B (subtask 2) ──├── Orchestrator (merge)
            └── Agent C (subtask 3) ──┘
```

**When to use:**
- The task can be decomposed into independent subtasks
- Subtasks don't need to communicate with each other
- Results can be merged mechanically (concatenation, deduplication, voting)
- Latency matters — parallel execution reduces wall-clock time

**When NOT to use:**
- Subtasks depend on each other's outputs
- The merge step requires complex reasoning (use Hierarchical instead)
- There are more subtasks than your concurrency limit allows

**Implementation Rules:**

1. **Decompose into truly independent units.** If subtask B needs output from
   subtask A, they are not independent. Test independence: "If I removed subtask
   A entirely, could subtask B still complete?" If no, they are dependent.

2. **Define the merge strategy before forking.** The orchestrator must know how to
   combine results BEFORE dispatching agents. Common merge strategies:

   | Strategy | Use When |
   |----------|----------|
   | **Concatenate** | Subtasks produce non-overlapping sections (e.g., review different files) |
   | **Deduplicate** | Subtasks may find the same things (e.g., search different sources) |
   | **Vote/Consensus** | Subtasks answer the same question (e.g., classification) |
   | **Best-of-N** | Subtasks produce alternative solutions; pick the highest quality |
   | **Union** | Subtasks produce complementary findings; take all |

3. **Set uniform timeouts.** All forked agents get the same time budget. The
   orchestrator waits for all to complete (or timeout). Don't let one slow agent
   block the entire pipeline.

4. **Handle partial failure gracefully.** If 1 of 3 agents fails, the orchestrator
   should still merge the 2 successful results and note the gap, not abort
   entirely.

**Example: Parallel Code Review**

```
TASK: Review a 500-line PR for quality, security, and performance.

FORK:
  Agent A: Review for code quality (naming, structure, complexity)
           Context: PR diff + project style guide
           Timeout: 60s

  Agent B: Review for security vulnerabilities (OWASP patterns)
           Context: PR diff + security checklist
           Timeout: 60s

  Agent C: Review for performance issues (N+1 queries, memory leaks)
           Context: PR diff + performance guidelines
           Timeout: 60s

MERGE STRATEGY: Union (combine all findings, deduplicate by file:line)

MERGE:
  1. Collect findings from A, B, C
  2. Deduplicate by location (same file:line → keep the more severe finding)
  3. Sort by severity (CRITICAL → LOW)
  4. Produce unified review report
```

---

### Pattern 2: Pipeline (Sequential Processing)

**Structure:**
```
Agent A → Agent B → Agent C → Final Output
 (stage 1)  (stage 2)  (stage 3)
```

**When to use:**
- Each stage transforms or enriches the output of the previous stage
- Stages require different expertise or context
- The task has a natural sequential flow (e.g., research → analyze → write)
- Quality improves by having a fresh agent review/refine previous work

**When NOT to use:**
- Stages are independent (use Fork-Join for parallelism)
- Later stages frequently need to loop back to earlier stages (use Blackboard)
- The pipeline is longer than 4 stages (diminishing returns, error accumulation)

**Implementation Rules:**

1. **Define stage interfaces explicitly.** Each stage must have a clearly defined
   input format and output format. The output of stage N must match the input
   of stage N+1.

   ```
   Stage 1 (Research):
     Input: Research question (string)
     Output: { findings: [{claim, source, confidence}], gaps: [string] }

   Stage 2 (Analysis):
     Input: { findings, gaps } from Stage 1
     Output: { analysis: string, recommendations: [{action, priority}] }

   Stage 3 (Report):
     Input: { analysis, recommendations } from Stage 2
     Output: Formatted markdown report
   ```

2. **Each stage gets ONLY the previous stage's output + its own instructions.**
   Don't pass the original task through all stages — this wastes context and
   causes agents to second-guess earlier stages.

3. **Add a validation step between stages.** Before passing output to the next
   stage, verify it meets the expected schema. Malformed intermediate output
   corrupts all downstream stages.

4. **Pipeline length limit: 4 stages maximum.** Each stage adds latency and error
   risk. If your pipeline has 5+ stages, consolidate stages with similar expertise.

**Example: Research-to-Report Pipeline**

```
TASK: Produce a technical comparison report of WebSocket vs. SSE.

STAGE 1 — Research Agent:
  Input: "Compare WebSocket and Server-Sent Events for real-time web apps"
  Instructions: Use recursive-research-synthesis skill
  Output: Research findings with confidence levels
  Validation: Must contain ≥5 findings, each with confidence level

STAGE 2 — Analysis Agent:
  Input: Research findings from Stage 1
  Instructions: Identify trade-offs, build decision matrix, find gaps
  Output: Structured analysis with comparison matrix
  Validation: Must contain comparison matrix with ≥4 dimensions

STAGE 3 — Writing Agent:
  Input: Analysis from Stage 2
  Instructions: Write executive-friendly report with recommendations
  Output: Final markdown report
  Validation: Must include executive summary, matrix, and recommendations
```

---

### Pattern 3: Auction (Competitive Selection)

**Structure:**
```
            ┌── Agent A (bid/proposal) ──┐
Orchestrator├── Agent B (bid/proposal) ──├── Orchestrator (select best)
            └── Agent C (bid/proposal) ──┘
```

**When to use:**
- The task has subjective quality (writing, design, creative solutions)
- You want the best of multiple approaches, not a merge of all approaches
- Different strategies might work — you want to explore the space
- Quality matters more than cost (you are paying for N agents but using 1 output)

**When NOT to use:**
- The task has a single correct answer (waste of resources)
- Budget is tight (you are paying for N× the work but keeping 1×)
- The selection criteria are unclear (you can't reliably pick the best)

**Implementation Rules:**

1. **Give each agent different constraints or approaches.**
   Don't just run 3 identical agents — vary their instructions:
   ```
   Agent A: "Solve this prioritizing readability and simplicity"
   Agent B: "Solve this prioritizing performance and efficiency"
   Agent C: "Solve this prioritizing extensibility and future-proofing"
   ```

2. **Define selection criteria BEFORE running agents.**
   ```
   SELECTION CRITERIA (weighted):
   - Correctness: 40%
   - Readability: 25%
   - Performance: 20%
   - Edge case handling: 15%
   ```

3. **Use a separate evaluator agent for selection** — not the orchestrator.
   The evaluator should receive all proposals without knowing which agent produced
   which (blind evaluation).

4. **Consider hybrid selection.** Sometimes the best result combines elements from
   multiple proposals. If your merge strategy supports it, take the best parts
   from each.

**Example: Solution Architecture Auction**

```
TASK: Design the data model for a multi-tenant SaaS notification system.

AUCTION:
  Agent A (shared-schema approach):
    Constraint: Use a single database with tenant_id columns
    Output: Schema design + trade-off analysis

  Agent B (schema-per-tenant approach):
    Constraint: Use separate schemas per tenant
    Output: Schema design + trade-off analysis

  Agent C (hybrid approach):
    Constraint: Free to combine approaches
    Output: Schema design + trade-off analysis

EVALUATOR (blind evaluation):
  Criteria: Scalability (30%), Query simplicity (25%),
            Data isolation (25%), Operational complexity (20%)
  Input: Three anonymized proposals
  Output: Ranked selection with justification
```

---

### Pattern 4: Blackboard (Shared Knowledge Base)

**Structure:**
```
            ┌── Agent A ──┐
Blackboard ←├── Agent B ──┤→ Blackboard (updated)
            └── Agent C ──┘
     ↑          ↑          ↑
     └──────────┴──────────┘
     (agents read/write shared state)
```

**When to use:**
- The problem requires iterative refinement from multiple perspectives
- Agents need to see each other's partial work
- The task doesn't have a clean sequential or parallel decomposition
- Knowledge from one agent's work triggers new work for another agent

**When NOT to use:**
- Tasks are cleanly independent (Fork-Join is simpler and cheaper)
- You can define a clear pipeline (Pipeline is more predictable)
- Agents will conflict on shared state (creates race conditions)

**Implementation Rules:**

1. **The blackboard is append-only.** Agents add information; they never delete
   or modify existing entries. This prevents destructive conflicts.

   ```
   BLACKBOARD SCHEMA:
   {
     "entries": [
       {
         "id": "entry-001",
         "agent": "security-reviewer",
         "timestamp": "2026-04-02T10:00:00Z",
         "type": "finding",
         "content": { ... },
         "supersedes": null  // or "entry-000" if this updates a previous entry
       }
     ]
   }
   ```

2. **Use a coordinator to manage access.** In practice, agents take turns reading
   the blackboard and adding entries. The coordinator determines which agent
   goes next based on what's on the blackboard.

   ```
   COORDINATION LOOP:
   1. Coordinator reads blackboard
   2. Coordinator decides which agent should act next
   3. Selected agent reads blackboard, does work, writes results
   4. Coordinator checks termination conditions
   5. If not terminated, go to step 1
   ```

3. **Define termination conditions.** Without them, blackboard patterns run
   forever:
   - Maximum iterations reached (e.g., 10 rounds)
   - No new entries added in last round (convergence)
   - All agents report "no further contribution"
   - Quality threshold met (evaluated by coordinator)

4. **Limit blackboard size.** Summarize old entries when the blackboard exceeds
   the context window. Keep the most recent and highest-impact entries; compress
   older entries into summaries.

**Example: Iterative Design Review**

```
TASK: Design an API for a complex scheduling system.

BLACKBOARD (initial):
  { "requirements": [...], "constraints": [...] }

ROUND 1:
  Agent A (API Designer): Reads requirements, proposes initial endpoint design
  → Writes: API spec v1 to blackboard

ROUND 2:
  Agent B (Security Reviewer): Reads API spec v1, identifies auth gaps
  → Writes: Security findings to blackboard

ROUND 3:
  Agent A (API Designer): Reads security findings, revises design
  → Writes: API spec v2 to blackboard (supersedes v1)

ROUND 4:
  Agent C (Consumer Tester): Reads API spec v2, writes sample client code
  → Writes: Usability findings to blackboard

ROUND 5:
  Agent A: Reads usability findings, makes final adjustments
  → Writes: API spec v3 (final) to blackboard

TERMINATION: 5 rounds complete, spec v3 has no open issues.
```

---

### Pattern 5: Hierarchical (Delegating Manager)

**Structure:**
```
              Manager Agent
             /      |      \
      Lead A     Lead B     Lead C
      /    \       |       /    \
  Worker  Worker Worker Worker  Worker
```

**When to use:**
- The task is too large for any single agent or simple pattern
- Sub-tasks themselves need to be decomposed further
- Different levels require different expertise (strategic vs. tactical)
- You need accountability — a clear chain of responsibility

**When NOT to use:**
- The task can be done in 1–2 levels (use Fork-Join or Pipeline)
- Delegation depth would exceed 3 levels (anti-pattern: see below)
- Manager agents would spend more time coordinating than workers spend working

**Implementation Rules:**

1. **Maximum depth: 3 levels.** Manager → Lead → Worker. Deeper hierarchies
   waste tokens on coordination overhead and increase error propagation.

2. **Manager responsibilities (and ONLY these):**
   - Decompose the task into sub-tasks for leads
   - Assign sub-tasks with clear success criteria
   - Merge and validate results from leads
   - Handle escalations from leads
   - Make go/no-go decisions

3. **Manager must NOT do worker-level work.** If the manager is writing code,
   reviewing files, or producing detailed analysis, the hierarchy is wrong.
   The manager's only outputs are: task assignments, merge results, and decisions.

4. **Budget allocation follows the 70/20/10 rule:**
   - 70% of token/time budget goes to workers (where actual work happens)
   - 20% goes to leads (for sub-task coordination and quality checks)
   - 10% goes to the manager (for decomposition and final merge)
   - If coordination cost exceeds 30%, reduce hierarchy depth.

5. **Escalation protocol:** Workers escalate to leads, leads escalate to manager.
   Never skip levels.
   ```
   ESCALATION TRIGGERS:
   - Ambiguous requirements → escalate for clarification
   - Conflicting constraints → escalate for priority decision
   - Out-of-scope discovery → escalate for scope adjustment
   - Task exceeds budget → escalate for re-planning
   ```

**Example: Large Codebase Migration**

```
TASK: Migrate a 50-file Python 2 codebase to Python 3.

MANAGER: Migration Coordinator
  Decomposes into 3 workstreams:
  1. Syntax migration (print statements, division, exceptions)
  2. Library compatibility (dependencies with Py3 equivalents)
  3. Test suite adaptation (test runner, assertions, mocking)

LEAD A: Syntax Migration Lead
  Coordinates 2 workers:
  - Worker A1: Migrate files in src/core/ (15 files)
  - Worker A2: Migrate files in src/api/ (12 files)

LEAD B: Library Lead
  Coordinates 1 worker:
  - Worker B1: Audit all dependencies, find Py3 equivalents,
               update requirements.txt

LEAD C: Test Lead
  Coordinates 2 workers:
  - Worker C1: Migrate test files (20 files)
  - Worker C2: Update CI configuration and test runner

MERGE: Manager collects all changes, runs integration test suite,
       resolves cross-workstream conflicts.
```

---

### Pattern Decision Matrix

Use this matrix to select the right pattern:

```
START
  │
  ├─ Can the task be split into independent subtasks?
  │   ├─ YES → Are all subtasks equivalent (same type of work)?
  │   │   ├─ YES → Do you want the best result or all results?
  │   │   │   ├─ ALL → Fork-Join (union merge)
  │   │   │   └─ BEST → Auction
  │   │   └─ NO → Fork-Join (concatenate merge)
  │   └─ NO → Do subtasks form a natural sequence?
  │       ├─ YES → Is it ≤4 stages?
  │       │   ├─ YES → Pipeline
  │       │   └─ NO → Consolidate stages, then Pipeline
  │       └─ NO → Do agents need to see each other's work?
  │           ├─ YES → Blackboard
  │           └─ NO → Is the task too large for one decomposition?
  │               ├─ YES → Hierarchical
  │               └─ NO → Re-examine — it might be a Pipeline
```

**Quick reference:**

| Pattern | Parallelism | Communication | Best For |
|---------|-------------|---------------|----------|
| Fork-Join | High | None between workers | Independent subtasks |
| Pipeline | None | Sequential handoff | Staged transformation |
| Auction | High | None between workers | Best-of-N quality |
| Blackboard | Variable | Shared state | Iterative refinement |
| Hierarchical | High within levels | Through managers | Large complex tasks |

---

### Anti-Patterns

#### Anti-Pattern 1: Infinite Delegation

```
Manager → "I'll delegate this" → Agent A → "I'll delegate this" →
Agent B → "I'll delegate this" → Agent C → ...
```

**Problem:** Each layer adds overhead but no value. The final worker gets a
watered-down version of the original task.

**Detection:** If more than 2 delegation hops occur before actual work starts.

**Fix:** Hard limit of 3 hierarchy levels. If a worker thinks it needs to
delegate, escalate to its lead instead.

#### Anti-Pattern 2: Circular Dependencies

```
Agent A needs output from Agent B
Agent B needs output from Agent A
→ Deadlock
```

**Detection:** Before dispatching, draw the dependency graph. If any cycle exists,
the design is wrong.

**Fix:** Break the cycle by having the orchestrator provide an initial estimate
or default value for one dependency, then iterate:
```
Round 1: Agent A runs with default for B's output → produces A1
Round 2: Agent B runs with A1 → produces B1
Round 3: Agent A runs with B1 → produces A2 (converged)
```

#### Anti-Pattern 3: Context Explosion

```
Orchestrator sends 4000 tokens of context to each of 5 agents
Each agent produces 2000 tokens of output
Orchestrator must process 10,000 tokens of agent output + original context
→ Exceeds context window, drops critical information
```

**Detection:** Calculate total context before dispatching:
```
Context per agent × number of agents + merge overhead < context window limit
```

**Fix:**
- Send each agent ONLY the context relevant to its subtask
- Require agents to produce structured, concise output (not prose)
- Have agents return summaries with an option to request details
- Compress intermediate results before passing to next stage

#### Anti-Pattern 4: Consensus Deadlock

```
3 agents vote on a decision
Agent A: Option X
Agent B: Option Y
Agent C: Option Z
→ No majority, no decision made
```

**Fix:** Always use an odd number of voters with a tiebreaking rule:
- Prefer the option from the most-specialized agent
- Prefer the more conservative option
- Escalate to a higher-tier model for the tiebreak

#### Anti-Pattern 5: State Corruption

```
Agent A reads shared file, starts processing
Agent B reads same shared file, starts processing
Agent A writes updated file
Agent B writes updated file → overwrites Agent A's changes
```

**Fix:**
- Use append-only shared state (Blackboard pattern)
- Use a coordinator to serialize access
- Have agents write to separate output locations, merge at orchestrator level

---

### Resource Budgeting

Before dispatching any multi-agent workflow, calculate the resource budget:

```
RESOURCE BUDGET:
┌─────────────────────────────────────────────────────┐
│ Token Budget                                         │
│ ├── Manager/Orchestrator: [X] tokens (target ≤10%)  │
│ ├── Leads (if hierarchical): [Y] tokens (target ≤20%)│
│ ├── Workers: [Z] tokens (target ≥70%)               │
│ └── Total: [X+Y+Z] tokens                          │
│                                                      │
│ Time Budget                                          │
│ ├── Sequential latency: [sum of pipeline stages]    │
│ ├── Parallel latency: [max of parallel workers]     │
│ └── Merge overhead: [estimated merge time]          │
│                                                      │
│ API Call Budget                                      │
│ ├── Agent spawns: [count]                           │
│ ├── Tool calls per agent: [estimated]               │
│ └── Total API calls: [calculated]                   │
│                                                      │
│ Failure Budget                                       │
│ ├── Acceptable failure rate: [X%]                   │
│ ├── Retry budget: [N retries per agent]             │
│ └── Graceful degradation plan: [what if N agents fail]│
└─────────────────────────────────────────────────────┘
```

**Budget Rules:**

1. **Never allocate >50% of budget to a single agent** in a multi-agent system.
   If one agent needs that much, the task doesn't need multi-agent orchestration.

2. **Reserve 15% of budget for retries and error handling.** Multi-agent systems
   have more failure modes than single agents.

3. **If coordination cost exceeds 30%, simplify.** Either reduce the number of
   agents or reduce hierarchy depth.

4. **Track actual vs. budgeted costs.** After each orchestration run, compare
   actual consumption to budget. Adjust future estimates.

---

### Error Handling Across Agent Boundaries

Errors in multi-agent systems are harder to handle because they cross boundaries:

#### Error Classification

| Error Type | Example | Handling |
|------------|---------|----------|
| **Agent failure** | Agent crashes, times out, produces empty output | Retry once, then proceed without (if non-critical) or escalate |
| **Quality failure** | Agent produces output that fails validation | Send back with error details for correction (max 2 retries) |
| **Budget exhaustion** | Agent exceeds token/time budget | Terminate and use partial results if usable |
| **Dependency failure** | Agent cannot complete because prerequisite failed | Provide default/fallback input, or skip dependent subtask |
| **Coordination failure** | Merge produces inconsistent results | Escalate to higher-tier model for manual merge |

#### Error Handling Protocol

```
ON ERROR:
  1. Classify error type
  2. Check retry budget (has this agent already retried?)
  3. If retries available → retry with additional context about the error
  4. If no retries → can the workflow continue without this agent's output?
     YES → Continue with degraded results, note the gap
     NO  → Escalate to orchestrator for re-planning
  5. Log error with: agent ID, error type, retry count, resolution
```

#### Partial Result Handling

When an agent partially completes:
```
1. Validate the partial output against the expected schema
2. Identify which parts are complete and which are missing
3. If ≥60% complete → use partial results + note gaps
4. If <60% complete → treat as failure, apply error handling protocol
```

---

### Managing Shared State Safely

When agents must share state, follow these rules:

1. **Prefer message passing over shared state.** Each agent receives input and
   produces output. The orchestrator manages state transitions.

2. **If shared state is necessary, use the Blackboard pattern** with append-only
   semantics.

3. **Never let agents read and write the same resource concurrently.** Use a
   coordinator to serialize access.

4. **Version shared state.** Every update to shared state creates a new version.
   Agents reference specific versions, not "current."

5. **Shared state has a size limit.** Define a maximum size and a compression
   strategy for when the limit is approached:
   ```
   MAX_BLACKBOARD_SIZE = 8000 tokens

   IF blackboard.size > MAX_BLACKBOARD_SIZE * 0.8:
     1. Summarize entries older than 3 rounds
     2. Remove entries marked as "superseded"
     3. Keep only the top 5 entries by impact score
   ```

## Examples

### Example 1: Fork-Join for Multi-File Code Review

```
TASK: Review PR #42 (changes across 8 files)

PATTERN: Fork-Join

DECOMPOSITION:
  Group files by type:
  - Agent A: Review backend changes (3 files: api.py, models.py, utils.py)
  - Agent B: Review frontend changes (3 files: App.tsx, hooks.ts, api.ts)
  - Agent C: Review test changes (2 files: test_api.py, App.test.tsx)

CONTEXT PER AGENT:
  - Only the diff for their assigned files
  - Project coding standards (shared, 200 tokens)
  - Total context per agent: ~1500 tokens

MERGE: Union with deduplication by finding location.

BUDGET:
  - Workers: 3 × 3000 tokens = 9000 tokens
  - Orchestrator: 1000 tokens (decompose + merge)
  - Total: 10,000 tokens
  - Parallel latency: max(Agent A, B, C) ≈ 15s
```

### Example 2: Pipeline for Document Generation

```
TASK: Generate a technical RFC from a feature request.

PATTERN: Pipeline (3 stages)

STAGE 1 — Requirements Analyst:
  Input: Feature request (user story + acceptance criteria)
  Output: Structured requirements { functional: [], non_functional: [],
           constraints: [], assumptions: [] }
  Validation: ≥3 functional requirements, ≥2 non-functional

STAGE 2 — Solution Architect:
  Input: Structured requirements from Stage 1
  Output: Technical design { components: [], interfaces: [], data_model: {},
           trade_offs: [] }
  Validation: ≥2 components, ≥1 trade-off analysis

STAGE 3 — Technical Writer:
  Input: Requirements + Technical design
  Output: Formatted RFC document (markdown)
  Validation: Has all required RFC sections, ≤2000 words

BUDGET:
  - Stage 1: 2000 tokens
  - Stage 2: 3000 tokens
  - Stage 3: 3000 tokens
  - Validation overhead: 500 tokens
  - Total: 8500 tokens
  - Sequential latency: ~45s
```

### Example 3: Error Recovery in Hierarchical Pattern

```
TASK: Migrate test suite (20 files)

PATTERN: Hierarchical (Manager → 2 Workers)

EXECUTION:
  Manager decomposes: Worker A gets 10 files, Worker B gets 10 files

  Worker A: Completes 10/10 files ✓
  Worker B: Fails after 6/10 files (context window exhausted)

ERROR HANDLING:
  1. Classify: Budget exhaustion
  2. Check partial results: 6/10 files complete (60%) → usable
  3. Manager creates Worker C for remaining 4 files
  4. Worker C completes 4/4 files ✓

MERGE:
  Manager combines: Worker A (10) + Worker B partial (6) + Worker C (4) = 20 ✓

COST: 1 retry, 3 workers instead of 2, 15% over budget — acceptable.
```

## Guidelines

1. **Start with the simplest pattern that could work.** Fork-Join handles 60% of
   multi-agent tasks. Don't use Hierarchical when Fork-Join suffices.

2. **Draw the dependency graph before coding.** Identify which subtasks depend on
   which. Cycles = redesign needed. Long chains = consider parallelizing.

3. **Give each agent the minimum context it needs.** Context explosion is the #1
   killer of multi-agent systems. If an agent doesn't need a piece of information,
   don't send it.

4. **Define output schemas, not just output descriptions.** "Produce a review"
   is ambiguous. "Produce a JSON object with fields: findings (array of
   {severity, location, description, fix})" is actionable.

5. **Budget for failure.** Reserve 15% of your total budget for retries. If no
   errors occur, you are under budget. If errors occur, you have headroom.

6. **Never exceed 3 levels of hierarchy.** The coordination tax grows
   quadratically with hierarchy depth. Manager → Lead → Worker is the maximum.

7. **Monitor for anti-patterns actively.** After each orchestration run, check:
   Did any agent delegate without doing work? Did coordination cost exceed 30%?
   Did any shared state get corrupted?

8. **Use timeouts on every agent.** An agent without a timeout is a memory leak.
   Set timeouts based on task complexity: simple (30s), medium (60s),
   complex (120s).

9. **Log everything.** For each agent: dispatch time, completion time, token usage,
   error count, output size. This data is essential for tuning future orchestrations.

10. **Prefer idempotent agents.** If you can safely re-run an agent with the same
    input and get the same output, error recovery is trivial. Design agent tasks
    to be side-effect-free when possible.
