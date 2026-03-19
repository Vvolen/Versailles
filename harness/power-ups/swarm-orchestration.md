# Swarm Orchestration — Power-Up Guide

## What Is Swarm Orchestration?

Swarm orchestration is the technique of coordinating multiple AI agents working in parallel toward a shared goal, with a hierarchical structure that prevents chaos and ensures results are merged correctly.

Versailles uses patterns from **RuFlo V3** (as implemented in MUNCH-CONTEXT-PROTOCOL-MCP-), adapted for GitHub Actions and claude-flow.

---

## The Hierarchy

```
ORCHESTRATOR (Tier 3 — Opus or Sonnet)
├── Plans the overall task
├── Assigns sub-tasks to specialists  
├── Monitors progress
└── Merges results
    │
    ├── SPECIALIST AGENT 1 (Tier 2 — Sonnet)
    │   └── Handles domain-specific subtask
    │
    ├── SPECIALIST AGENT 2 (Tier 2 — Sonnet)
    │   └── Handles domain-specific subtask
    │
    └── VALIDATOR AGENT (Tier 1 — Haiku)
        └── Checks outputs against criteria
```

**Rule from CLAUDE.md:** Maximum 2 levels of nesting. Specialists cannot spawn specialists.

---

## Topology Types

### Linear Pipeline (most common in Versailles)
Each agent feeds its output to the next:
```
Scout → Bouncer → Evaluator → Evolver
```
Use when: tasks have strict ordering requirements (security must come before eval)

---

### Parallel Fan-Out
Multiple agents work simultaneously on independent subtasks:
```
          ┌→ Scout (MCPs) ───────────┐
          ├→ Scout (Skills) ──────── ├→ Merger
          └→ Scout (Agents) ─────────┘
```
Use when: subtasks are independent and order doesn't matter

---

### Recursive Depth
An agent spawns deeper specialists as complexity increases:
```
Researcher (depth 1)
  └→ Researcher (depth 2, narrower topic)
       └→ Researcher (depth 3, specific question)
```
Use when: research or analysis needs iterative deepening
**Limit: 3 levels max** (cost explosion risk)

---

## Implementing with claude-flow

```bash
# 1. Start orchestrator
claude-flow swarm start \
  --orchestrator "claude-sonnet-4-5" \
  --max-agents 5 \
  --task "Research and catalog the top 10 MCP servers"

# 2. Orchestrator spawns scouts
claude-flow agent spawn scout --parallel 3

# 3. Results flow back to orchestrator
claude-flow swarm collect --output catalog/mcps.json
```

---

## Implementing in GitHub Actions

```yaml
jobs:
  orchestrate:
    runs-on: ubuntu-latest
    outputs:
      plan: ${{ steps.plan.outputs.plan }}
    steps:
      - name: Create orchestration plan
        id: plan
        run: python3 orchestrate.py --task "catalog MCPs"

  execute:
    needs: orchestrate
    strategy:
      matrix:
        subtask: ${{ fromJSON(needs.orchestrate.outputs.plan) }}
      max-parallel: 5
    steps:
      - name: Execute subtask
        run: python3 execute.py --task "${{ matrix.subtask }}"

  merge:
    needs: execute
    steps:
      - name: Merge all results
        run: python3 merge.py
```

---

## Concurrency Rules (from CLAUDE.md)

| Rule | Value | Reason |
|------|-------|--------|
| Max concurrent agents | 5 | Prevents cost explosion |
| Max nesting depth | 2 | Prevents recursive spirals |
| Agent timeout | 30 min | Prevents hanging agents |
| Required: unique task IDs | Yes | Audit trail |
| Required: heartbeat | Every 10 actions | Anti-drift |

---

## Anti-Drift Checkpoints

Every agent in a swarm must emit a heartbeat every 10 actions:

```
[HEARTBEAT | AGENT: scout-1 | TASK: discover-mcps | STEP: 7/10]
Status: Found 34 repos, scoring now...
Next: Write discovery files
On track: YES
```

If an agent misses 2 heartbeats → orchestrator kills it and reassigns the task.

---

## The Merge Contract

Every agent in a swarm must:
1. Write outputs to a **unique, predictable path** (e.g., `tmp/scout-{id}-results.json`)
2. Use a **defined output schema** so the merger can parse it
3. Emit a **COMPLETE** signal when done

The orchestrator never trusts an agent that didn't emit COMPLETE.

---

*Based on: RuFlo V3 architecture from MUNCH-CONTEXT-PROTOCOL-MCP- | Versailles v1.0*
