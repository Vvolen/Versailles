# HARNESS_ENGINEERING.md — Environment > Model

> The most powerful thing you can do for an AI agent is not give it a better model.
> It's give it a better environment.

---

## What Is an Agentic Harness?

A **harness** is the complete environment in which an AI agent operates. It includes:

- **Context** — What the agent knows before it starts (CLAUDE.md, SOUL.md, task description)
- **Tools** — What the agent can do (MCP servers, GitHub API, file system)
- **Memory** — What the agent can remember across tasks (git-tracked files, catalog)
- **Skills** — What the agent has learned (evolved/ directory)
- **Rules** — How the agent must behave (security rules, concurrency limits)
- **Routing** — Which model tier to use for which task

Together, these form a harness that shapes every output the agent produces.

---

## Why Environment > Model

Consider two scenarios:

**Scenario A: GPT-3 with a great harness**
- Agent starts with complete context about the task
- Has access to relevant tools (GitHub search, file system)
- Has prior examples of successful similar tasks
- Has clear rules about format and security
- Has memory of what's been tried before

**Scenario B: GPT-4 with no harness**
- Agent starts with a vague prompt
- Has no tools beyond text generation
- No examples, no rules, no memory

Scenario A produces better outputs. Every time. The harness amplifies model capability.

This is why Versailles invests heavily in `CLAUDE.md`, SOUL.md files, the MCP configuration, and the skill pipeline — these are harness investments that pay dividends on every single agent interaction.

---

## The Harness Stack

```
┌─────────────────────────────────────┐
│           TASK INPUT                │  ← Issue, workflow trigger, direct prompt
├─────────────────────────────────────┤
│        IDENTITY LAYER               │  ← CLAUDE.md + SOUL.md
│  (Who am I? What are my values?)   │
├─────────────────────────────────────┤
│        CONTEXT LAYER                │  ← Progressive disclosure
│  (What do I know right now?)       │  ← Level 0 → Level 1 → Level 2
├─────────────────────────────────────┤
│         TOOLS LAYER                 │  ← MCP servers (.mcp.json)
│  (What can I do?)                  │  ← GitHub, filesystem, claude-flow
├─────────────────────────────────────┤
│         MEMORY LAYER                │  ← Git-tracked files
│  (What have I learned?)            │  ← catalog/, skills/evolved/
├─────────────────────────────────────┤
│         SKILLS LAYER                │  ← skills/evolved/ content
│  (What capabilities do I have?)    │  ← Tested, evolved prompt modules
├─────────────────────────────────────┤
│          MODEL TIER                 │  ← Haiku / Sonnet / Opus
│  (How much reasoning do I need?)   │  ← Routed by CLAUDE.md rules
└─────────────────────────────────────┘
```

Each layer amplifies the one above it. The model is at the bottom — important, but not the primary lever.

---

## Progressive Disclosure as Design Principle

**Progressive disclosure** means giving an agent only the context it needs for its current task stage, and loading additional context only when required.

### Why It Matters

1. **Context is finite** — Every model has a context window limit. Dumping everything in at once wastes tokens and degrades performance.
2. **Attention dilution** — Models pay less attention to details buried in a sea of text. Smaller, focused context = better reasoning.
3. **Cost** — API calls are priced by token. Unnecessary context = unnecessary cost.

### Levels of Disclosure

| Level | Contents | When to Load |
|-------|----------|-------------|
| 0 | CLAUDE.md + SOUL.md + task | Always — agent cold-start |
| 1 | Relevant methodology docs (CRITERIA.md, etc.) | When task requires domain knowledge |
| 2 | Specific skill files, research findings | When processing specific artifacts |
| 3 | Full git history, raw API responses | Rarely — only for deep forensics |

### Implementation Pattern

```
# Level 0 context (always in system prompt)
system = load("CLAUDE.md") + load("agents/{role}/SOUL.md") + task_description

# Level 1 (add when needed)
if task_type == "security_review":
    system += load("agents/bouncer/SECURITY_CHECKS.md")

# Level 2 (add when processing specific artifact)
if processing_skill:
    system += load(skill_file_path)

# Level 3 (rare, justified)
if deep_forensics_needed:
    system += load_git_history()
```

---

## Composing Harnesses from MCPs

MCP (Model Context Protocol) servers are the **tool layer** of the harness. Each MCP adds specific capabilities:

### Versailles MCP Stack (`.mcp.json`)

| MCP | Adds to Harness |
|-----|----------------|
| `claude-flow` | Spawn and coordinate sub-agents |
| `context7` | Real-time library documentation |
| `filesystem` | Safe file read/write within repo |
| `github` | GitHub API: search, issues, PRs |
| `sequential-thinking` | Step-by-step reasoning mode |

### MCP Gateway Pattern

The `harness/mcp-gateway.json` configures **progressive MCP disclosure** — agents only get access to the MCPs they need for their role:

- **Scout:** github + filesystem
- **Bouncer:** filesystem + sequential-thinking
- **Evaluator:** filesystem (no external calls needed)
- **Evolver:** filesystem + sequential-thinking
- **Researcher:** github + sequential-thinking + filesystem
- **Orchestrator:** all MCPs

This limits blast radius if an agent goes rogue or makes mistakes.

---

## Memory Architecture

Versailles uses **git as memory**. Every agent action is a commit. The full history of every decision is auditable.

```
skills/evolved/tool-x-v1-evolved.md    ← Memory of what was learned
skills/evolved/tool-x-v2-evolved.md    ← Memory of how it improved
catalog/tools.json                      ← Memory of what exists
catalog/CHANGELOG.md                    ← Memory of what happened
research/findings/topic-2026-03-19.md  ← Memory of what was researched
```

This is more durable and auditable than vector databases for the use cases in Versailles, because:
- No vector DB infrastructure to maintain
- Fully human-readable
- Git diff shows exactly what changed and when
- Rollback is trivial (`git revert`)
- Every change has an author and message

---

## Harness Anti-Patterns

Avoid these:

❌ **Dumping the whole repo in context** — destroys attention, wastes tokens
❌ **No SOUL.md for agents** — agents without identity drift
❌ **Skipping the skill pipeline** — unvetted skills poison the catalog
❌ **No generation tracking** — impossible to audit or rollback evolution
❌ **Tier 3 for Tier 1 tasks** — Opus for JSON validation is waste
❌ **Unconstrained sub-agent spawning** — exponential cost explosion

---

## Related Resources

- **CLAUDE.md** — The constitution that implements these principles
- **`.mcp.json`** — The MCP configuration
- **`harness/mcp-gateway.json`** — Role-based MCP access control
- **`harness/agent-bootstrap.sh`** — Startup script
- **`harness/power-ups/`** — Reusable capability modules

---

*Updated: 2026-03-19 | Core philosophy of the Versailles repository*
