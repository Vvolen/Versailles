# Context Forking — Power-Up Guide

## What Is Context Forking?

Context forking is the technique of **splitting a large task into independent parallel sub-tasks**, each handled by a separate agent instance with its own focused context window. The parent agent spawns the forks, each fork works independently, and the parent merges results.

Think of it like Git branching: you branch off, work in isolation, then merge back.

---

## Why Fork Context?

1. **Parallelism** — Multiple tasks complete simultaneously instead of sequentially
2. **Focus** — Each sub-agent only sees what it needs (progressive disclosure)
3. **Isolation** — A failing fork doesn't corrupt the parent's context
4. **Cost** — Smaller, focused contexts are cheaper than one massive context

---

## The Fork Pattern

```python
# Pattern: Fork → Parallel Execute → Merge

# 1. Define the task that benefits from parallelism
task = "Evaluate top 5 MCP servers for agent memory"

# 2. Split into independent sub-tasks
subtasks = [
    {"id": "fork-1", "focus": "Evaluate mcp-memory-server"},
    {"id": "fork-2", "focus": "Evaluate chroma-mcp"},
    {"id": "fork-3", "focus": "Evaluate pinecone-mcp"},
    {"id": "fork-4", "focus": "Evaluate qdrant-mcp"},
    {"id": "fork-5", "focus": "Evaluate weaviate-mcp"},
]

# 3. Each fork gets MINIMAL context — only what it needs
fork_context = {
    "task": subtasks[i],
    "criteria": load("agents/scout/CRITERIA.md"),    # Level 1 context
    # NOT: full catalog, full history, all skill files
}

# 4. Run forks (in GitHub Actions: parallel job matrix)
results = run_in_parallel(subtasks, context=fork_context)

# 5. Parent merges results
merged = merge_and_rank(results)
```

---

## Implementing in GitHub Actions

GitHub Actions natively supports parallel jobs with matrices:

```yaml
jobs:
  fork:
    strategy:
      matrix:
        mcp: [mcp-memory-server, chroma-mcp, pinecone-mcp]
      max-parallel: 3  # Concurrency limit from CLAUDE.md
    steps:
      - name: Evaluate ${{ matrix.mcp }}
        run: python3 evaluate_single.py --target ${{ matrix.mcp }}

  merge:
    needs: fork  # Wait for all forks
    steps:
      - name: Merge results
        run: python3 merge_results.py
```

---

## Implementing with claude-flow

```bash
# Spawn 3 parallel scout agents
claude-flow agent spawn scout \
  --task "Search GitHub for MCP servers in category: memory" \
  --context "agents/scout/SOUL.md agents/scout/CRITERIA.md" \
  --output "skills/discovered/memory-mcps.json" &

claude-flow agent spawn scout \
  --task "Search GitHub for MCP servers in category: search" \
  --context "agents/scout/SOUL.md agents/scout/CRITERIA.md" \
  --output "skills/discovered/search-mcps.json" &

claude-flow agent spawn scout \
  --task "Search GitHub for MCP servers in category: storage" \
  --context "agents/scout/SOUL.md agents/scout/CRITERIA.md" \
  --output "skills/discovered/storage-mcps.json" &

# Wait for all to complete
wait

# Merge
claude-flow merge \
  --inputs "skills/discovered/*-mcps.json" \
  --output "catalog/mcps.json" \
  --dedup-by "url"
```

---

## Rules for Forking (from CLAUDE.md)

1. **Maximum 5 concurrent forks** per parent agent
2. **Each fork has a timeout** — if a fork doesn't complete in N seconds, kill it and continue with partial results
3. **Forks share NO mutable state** — each fork gets a COPY of context, not a reference
4. **Merge is done by parent only** — forks never merge each other
5. **No fork spawns forks** (max depth = 2 levels)

---

## Anti-Patterns

❌ **Infinite forking** — Spawning forks that spawn forks that spawn forks. Hard limit: 2 levels deep.

❌ **Shared mutable state** — Two forks writing to the same file simultaneously causes corruption. Use unique output files.

❌ **Forking for small tasks** — Overhead of forking isn't worth it for tasks < 30 seconds. Fork only for tasks that benefit from parallelism.

❌ **Forking without timeouts** — A hanging fork blocks the merge forever. Always set timeouts.

---

*Used by: claude-flow orchestration, GitHub Actions matrix jobs*
