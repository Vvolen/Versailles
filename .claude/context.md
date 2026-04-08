# Versailles — Agent Project Context

> Load this file when starting a session in this repo. ~600 tokens.
> Full constitution: `CLAUDE.md` | Full architecture: `docs/ARCHITECTURE.md`

---

## What This Repo Is

Versailles is an **autonomous skill discovery and evolution engine** built entirely on GitHub infrastructure (Actions, Codespaces, Issues). No external databases, no servers to run.

**It does five things:**
1. Scout GitHub for AI skills / MCP servers / tools (every 6 hours)
2. Vet discoveries through a zero-trust security bouncer
3. A/B test vetted skills against a Claude baseline
4. Evolve winning skills via TDD mutation cycles
5. Serve best skills to humans and agents via progressive disclosure

**Owner:** Vvolen (non-developer architect; works from iPad; uses voice dictation)

---

## File Layout (What Matters)

```
CLAUDE.md              ← Agent constitution — read this first, always
AGENT_NOTES.md         ← Append-only cross-agent journal (read last 3 entries)
harness/agent-bootstrap.sh  ← Run before starting work
docs/STATE_AND_DELTAS.md    ← Current status + recent changes + gaps
catalog/CHANGELOG.md        ← Every agent action logged here
skills/                ← discovered → quarantine OR evaluated → evolved
projects/              ← discovered → vetted (no evolution)
agents/<role>/SOUL.md  ← Identity file per agent
```

---

## Active Agent Roles

| Role | Trigger | Purpose |
|------|---------|---------|
| Scout | Every 6h | Wide-net discovery of tools/skills |
| Explorer | Weekly | Deep gem hunting, 6-dimension scoring |
| Bouncer | On push to discovered/ | Zero-trust security vetting |
| Evaluator | On push to evaluated/ | A/B test vs Claude baseline |
| Evolver | Daily 2 AM | TDD mutation of evolved skills |
| Researcher | Issue labeled research-request | Recursive deep research |

---

## Required Secrets

| Secret | Used By |
|--------|---------|
| `GITHUB_TOKEN` | All workflows (auto-provided) |
| `ANTHROPIC_API_KEY` | Evaluator, Evolver, Research, Agentic Planner |

---

## Swarm Pattern (Ruflo 2-worker + orchestrator)

```bash
# From Codespaces terminal — standard Versailles swarm
ruflo swarm start \
  --orchestrator claude-sonnet \
  --workers 2 \
  --task "your task here" \
  --context CLAUDE.md \
  --max-agents 5

# Or using the legacy alias (same binary):
claude-flow swarm start --orchestrator claude-sonnet --workers 2
```

---

## Security Rules (Non-Negotiable)

- Quarantine first, ask questions later
- Never execute unvetted code
- No credentials in skill files
- 37% of openly published AI skills contain malicious patterns — trust nothing by default

---

*See `docs/STATE_AND_DELTAS.md` for current pipeline status and what's missing.*
