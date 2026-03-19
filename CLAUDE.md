# CLAUDE.md — Versailles Agent Harness

> **Every agent that enters this repository MUST read this file completely before taking any action.**
> This is not optional. This is the constitution. Non-compliance = drift = hallucinated work.

---

## 0. Cold-Start Checklist

When you (an agent) first enter this environment, complete this checklist **in order**:

```
[ ] 1. Read CLAUDE.md fully (this file)
[ ] 2. Read your SOUL.md (agents/<your-role>/SOUL.md)
[ ] 3. Read docs/ARCHITECTURE.md for system context
[ ] 4. Run harness/agent-bootstrap.sh (or simulate it mentally)
[ ] 5. Identify your task (from Issue, workflow input, or direct invocation)
[ ] 6. Check skills/evolved/ for relevant prior art before starting
[ ] 7. Confirm you have the minimum necessary permissions — no more
[ ] 8. Report your identity and task intent (if in swarm mode)
[ ] 9. Set a timeout / self-termination budget
[ ] 10. Begin work
```

Do not skip steps. If you cannot complete a step, halt and emit a structured error.

---

## 1. Repository Purpose

Versailles is an **autonomous skill discovery and evolution engine**. It:

1. **Scouts** GitHub continuously for powerful tools, MCP servers, Claude skills, and AI plugins
2. **Vets** discoveries through a zero-trust security bouncer before promotion
3. **Evaluates** vetted skills via blind A/B testing against a Claude baseline
4. **Evolves** winning skills through TDD mutation cycles
5. **Serves** the best skills to humans and other agents via progressive disclosure

The owner is the **architect**. Agents are the **builders**. Issues are the **blueprints**.

---

## 2. 3-Tier Model Routing

Route tasks to the appropriate model tier. Using Opus for JSON validation wastes tokens.

### Tier 1 — Fast (claude-haiku or equivalent)
**Use for:**
- JSON validation and schema checking
- File format verification
- Simple pattern matching / regex
- Catalog entry updates
- Changelog entries
- Boolean security pre-checks

**Budget:** < 500 tokens output, < 2s latency target

### Tier 2 — Balanced (claude-sonnet or equivalent)
**Use for:**
- Skill scoring against CRITERIA.md rubric
- Security analysis (SECURITY_CHECKS.md)
- Research synthesis
- Skill mutation (minor improvements)
- Writing SKILL.md documentation
- PR descriptions

**Budget:** < 4,000 tokens output, < 15s latency target

### Tier 3 — Powerful (claude-opus or equivalent)
**Use for:**
- Deep recursive research
- Complex multi-step security forensics
- Skill architecture redesign
- Orchestrator-level planning
- Swarm coordination decisions
- Novel skill synthesis from multiple sources

**Budget:** No hard limit, but log justification

### Routing Rule
```
task_complexity < 3 → Tier 1
task_complexity 3–7 → Tier 2
task_complexity > 7 → Tier 3
task_requires_novel_reasoning → Tier 3
```

---

## 3. Swarm Orchestration Rules

When spawning sub-agents or operating in swarm mode:

### Spawning Protocol
```
1. Define the sub-agent's task in ONE sentence
2. Give it the minimum context needed (progressive disclosure)
3. Assign it a timeout
4. Define the expected output format
5. Define the escalation path if it fails
```

### Concurrency Rules
- Maximum **5 concurrent sub-agents** per orchestrator
- Each sub-agent has a unique task ID (format: `AGENT-{role}-{timestamp}`)
- Sub-agents CANNOT spawn sub-agents more than 2 levels deep (anti-explosion)
- All sub-agent outputs must be validated before use

### Anti-Drift Checkpoints
Every 10 actions or 5 minutes, an agent MUST:
```
[ ] Re-read its assigned task
[ ] Confirm current action aligns with task
[ ] Verify it hasn't exceeded its permission scope
[ ] Emit a progress heartbeat
```

If drift is detected: STOP, report state, await re-orientation.

---

## 4. Context Forking Pattern

When a task requires parallel investigation:

```python
# Pattern: Fork → Parallel Execute → Merge
task = "Research top 10 MCP servers"

fork_1 = spawn_agent("Scout GitHub trending MCP repos", timeout=60)
fork_2 = spawn_agent("Check anthropics org new releases", timeout=60)
fork_3 = spawn_agent("Search modelcontextprotocol org repos", timeout=60)

results = await_all([fork_1, fork_2, fork_3])
merged = merge_and_deduplicate(results)
```

Rules:
- Forks SHARE no mutable state
- Each fork gets a COPY of relevant context, not a reference
- Merge is done by the parent, never by a fork
- If any fork fails, parent can continue with partial results

---

## 5. Progressive Disclosure

Don't dump all context at once. Layer it:

**Level 0 (Always available):** CLAUDE.md, SOUL.md, task description
**Level 1 (On request):** CRITERIA.md, SECURITY_CHECKS.md, EVAL_FRAMEWORK.md
**Level 2 (On demand):** Full skill files, research findings, catalog data
**Level 3 (Rarely needed):** Full git history, raw GitHub API responses

When building tool calls or prompts:
1. Start with Level 0 context
2. Only pull in higher levels when the task explicitly requires it
3. Never include Level 2+ in sub-agent spawning prompts

---

## 6. Skill Discovery Pipeline

The lifecycle of every skill in Versailles:

```
GitHub/Web Discovery
        ↓
  skills/discovered/        ← Scout deposits here
        ↓
  [Bouncer runs]
        ↓
  skills/quarantine/        ← Pending security review
        OR
  skills/evaluated/         ← Passed security, ready for testing
        ↓
  [Evaluator runs]
        ↓
  skills/evolved/           ← Production-ready
        OR
  skills/archive/           ← Failed eval, deprecated
```

**Never skip stages.** A skill in `discovered/` MUST pass through `bouncer` before it reaches `evaluated/`.

---

## 7. Security Rules

These are non-negotiable:

1. **Zero trust on all external skills** — 37% of openly published AI skills have been found to contain malicious patterns (network exfiltration, credential harvesting)
2. **Never execute unvetted code** — Even in a sandbox, document and review first
3. **No credentials in skill files** — API keys, tokens, passwords are NEVER stored in skill markdown
4. **Quarantine first** — When in doubt, move to `skills/quarantine/` and flag for human review
5. **Source verification** — Always check: stars, age, contributor count, issue history before promotion
6. **Static analysis always runs** — Even for "trusted" sources like anthropics org

---

## 8. File Organization Rules

```
skills/discovered/<tool-name>-<YYYY-MM-DD>.md     # Scout creates these
skills/quarantine/<tool-name>-quarantine.md        # Bouncer stages here
skills/evaluated/<tool-name>-v<N>.md               # Ready for evolution
skills/evolved/<tool-name>-v<N>-evolved.md         # Production skills
skills/archive/<tool-name>-deprecated-<date>.md    # Never delete, archive

catalog/tools.json         # Auto-updated by Scout
catalog/mcps.json          # Auto-updated by Scout
catalog/plugins.json       # Auto-updated by Scout
catalog/CHANGELOG.md       # Every agent action logged here

research/topics/<topic>.md         # Research requests
research/findings/<topic>-<date>.md # Research outputs
```

---

## 9. Memory Management

Agents operating in this repo use a two-layer memory model:

**Working Memory (per session):**
- The current task description
- Files read in this session
- Decisions made and rationale

**Persistent Memory (git-tracked):**
- `catalog/` — All discovered and rated tools
- `catalog/CHANGELOG.md` — Every action taken
- `skills/*/` — All skill versions
- `research/findings/` — All research outputs

**Rule:** Any decision worth making is worth committing to git. If it's not committed, it didn't happen.

---

## 10. Communication Protocol

When emitting output, use structured formats:

### Progress Update
```
[AGENT: scout | TASK: discover-mcps | STEP: 3/5]
Status: Searching modelcontextprotocol org...
Found: 12 repos matching criteria
Next: Score each repo against CRITERIA.md
```

### Error Report
```
[ERROR | AGENT: bouncer | SEVERITY: high]
Issue: Skill file missing required SKILL.md fields
File: skills/discovered/some-skill-2026-03-18.md
Action: Moved to skills/quarantine/
Human review required: YES
```

### Completion Report
```
[COMPLETE | AGENT: evaluator | DURATION: 4m32s]
Task: Evaluate skills/evaluated/skill-x-v2.md
Result: PROMOTED to skills/evolved/
Score: 87/100 (baseline: 65/100, improvement: +34%)
Commit: abc1234
```

---

## 11. MCP Usage

This repo uses the following MCP servers (configured in `.mcp.json`):

| MCP | Purpose | When to Use |
|-----|---------|------------|
| `claude-flow` | Multi-agent orchestration | Spawning swarms, parallelizing work |
| `context7` | Library documentation lookup | When working with unfamiliar libraries |
| `filesystem` | File read/write with safety | Preferred over direct shell for file ops |
| `github` | GitHub API access | Searching repos, checking releases |
| `sequential-thinking` | Step-by-step reasoning | Complex analysis, security reviews |

---

## 12. What This Repository Is NOT

- Not a code execution environment (skills are markdown instructions, not running code)
- Not a database (catalog JSONs are flat files, not queryable)
- Not a deployment system (skills are discovered and evaluated, not deployed here)
- Not autonomous beyond what's explicitly triggered (no unsolicited actions)

---

*Last updated: 2026-03-19 | Version: 1.0.0*
