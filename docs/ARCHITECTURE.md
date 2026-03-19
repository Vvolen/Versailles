# Architecture — Versailles System Design

## Overview

Versailles is a **self-evolving skill discovery and orchestration engine** built entirely on GitHub infrastructure (Actions, Issues, Codespaces, Copilot). It has no external databases, no custom servers, and no infrastructure to maintain.

Everything is files + git + GitHub Actions.

---

## Full System Diagram

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                           VERSAILLES SYSTEM                                  │
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │                         INPUT LAYER                                     │ │
│  │                                                                         │ │
│  │   GitHub Issues        GitHub Actions        Direct Trigger             │ │
│  │   (research req,       (scheduled crons,     (workflow_dispatch)        │ │
│  │    skill discovery,     push triggers)                                  │ │
│  │    evolution req)                                                       │ │
│  └───────────────────────────────┬─────────────────────────────────────────┘ │
│                                  │                                           │
│  ┌───────────────────────────────▼─────────────────────────────────────────┐ │
│  │                         AGENT LAYER                                     │ │
│  │                                                                         │ │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐ │ │
│  │  │  SCOUT   │  │ BOUNCER  │  │EVALUATOR │  │ EVOLVER  │  │RESEARCHER│ │ │
│  │  │ scout.yml│  │bouncer   │  │ eval.yml │  │evolve.yml│  │research  │ │ │
│  │  │          │  │  .yml    │  │          │  │          │  │  .yml    │ │ │
│  │  │Every 6h  │  │On push   │  │On push   │  │Daily 2AM │  │On issue  │ │ │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘ │ │
│  │       │              │              │              │              │       │ │
│  └───────┼──────────────┼──────────────┼──────────────┼──────────────┼───────┘ │
│          │              │              │              │              │         │
│  ┌───────▼──────────────▼──────────────▼──────────────▼──────────────▼───────┐ │
│  │                      SKILL PIPELINE                                       │ │
│  │                                                                           │ │
│  │  skills/             skills/          skills/         skills/  skills/   │ │
│  │  discovered/  ──▶    quarantine/  ▶   evaluated/  ▶   evolved/ archive/  │ │
│  │  (scout)             (failed)         (bouncer OK)    (eval OK)(retired) │ │
│  └───────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ┌───────────────────────────────────────────────────────────────────────────┐ │
│  │                       PERSISTENCE LAYER                                  │ │
│  │                                                                          │ │
│  │  catalog/tools.json     catalog/mcps.json     catalog/plugins.json      │ │
│  │  catalog/CHANGELOG.md   research/findings/    git log (full audit)      │ │
│  └───────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ┌───────────────────────────────────────────────────────────────────────────┐ │
│  │                         HARNESS LAYER                                    │ │
│  │                                                                          │ │
│  │  CLAUDE.md (constitution)  •  .mcp.json (tools)  •  agent-bootstrap.sh  │ │
│  │  3-tier routing  •  swarm rules  •  progressive disclosure               │ │
│  └───────────────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## Data Flow

### Skill Discovery Flow
```
1. Scout workflow runs (cron: every 6h)
2. Scout searches GitHub API for tools matching categories
3. Scout scores each tool (0-100) using CRITERIA.md rubric
4. Tools scoring ≥ 20 → written to skills/discovered/<name>-<date>.md
5. catalog/tools.json updated with new entries
6. Push triggers Bouncer workflow
```

### Security Vetting Flow
```
1. Bouncer workflow triggers on push to skills/discovered/
2. Bouncer loads each new discovery file
3. Bouncer runs 4-phase security check:
   Phase 1: Static pattern analysis (critical patterns = auto-quarantine)
   Phase 2: Reputation check via GitHub API (stars, age, forks)
   Phase 3: Source analysis (README spot-check)
   Phase 4: Final score calculation
4. Pass (score ≥ 30, 0 critical): → skills/evaluated/<name>-v1.md
5. Fail: → skills/quarantine/<name>-quarantine.md
6. Security report appended to file
7. Commit with "Bouncer Agent" authorship
```

### Evaluation Flow
```
1. Evaluator workflow triggers on push to skills/evaluated/
2. Generates 3 targeted test scenarios for the skill
3. Runs A/B test:
   A: Claude + skill as system prompt + test prompt
   B: Claude + no system prompt + same test prompt
4. Scores both responses (0-100) using Haiku
5. Calculates improvement %
6. ≥ 15% improvement: → skills/evolved/<name>-v1-evolved.md
7. < 15% improvement: → skills/archive/
8. Eval report appended to file
```

### Evolution Flow
```
1. Evolver workflow runs (cron: daily at 2 AM UTC)
2. Selects up to 3 skills from skills/evolved/
3. For each skill:
   a. Generates test prompts
   b. Scores current version
   c. Applies 3 mutation strategies (refinement, compression, expansion)
   d. Scores each mutant
   e. Best mutant with ≥ 5% improvement → new version (v2, v3...)
   f. Old version → skills/archive/
4. Stagnant skills (5 gens, <2% improvement) → retired
```

### Research Flow
```
1. Owner creates Issue using "Research Request" template
2. Owner labels issue "research-request"
3. Researcher workflow triggers
4. Iterative research loop (1-7 iterations based on depth setting)
5. Each iteration builds on previous
6. Final report compiled → research/findings/<topic>-<date>.md
7. PR opened with findings
8. Issue commented with summary
```

---

## Component Map

| Component | Files | Purpose |
|-----------|-------|---------|
| Agent Constitution | `CLAUDE.md` | Rules every agent follows |
| MCP Config | `.mcp.json` | Tool access for agents |
| MCP Gateway | `harness/mcp-gateway.json` | Role-based tool access control |
| Bootstrap | `harness/agent-bootstrap.sh` | Environment setup script |
| Scout Agent | `agents/scout/` | Discovery identity and criteria |
| Bouncer Agent | `agents/bouncer/` | Security identity and checklist |
| Evaluator Agent | `agents/evaluator/` | Testing identity and framework |
| Evolver Agent | `agents/evolver/` | Evolution identity and rules |
| Scout Workflow | `.github/workflows/scout.yml` | Automated discovery (6h) |
| Bouncer Workflow | `.github/workflows/bouncer.yml` | Security vetting |
| Eval Workflow | `.github/workflows/eval.yml` | A/B testing |
| Evolve Workflow | `.github/workflows/evolve.yml` | TDD mutation (daily) |
| Research Workflow | `.github/workflows/research.yml` | Deep research |
| Self-Heal Workflow | `.github/workflows/self-heal.yml` | Integrity validation |
| Skill Pipeline | `skills/` | 5-stage skill lifecycle |
| Catalog | `catalog/` | JSON catalogs + changelog |
| Research | `research/` | Topics + findings |
| Power-Ups | `harness/power-ups/` | Capability modules |
| Docs | `docs/` | Human-readable guides |

---

## Integration With Related Repositories

```
┌─────────────────────┐     ┌─────────────────────┐
│  Foundation-layer   │     │  MUNCH-CONTEXT-      │
│  (NickOS engine)    │     │  PROTOCOL-MCP-       │
│                     │     │  (RuFlo V3 harness)  │
│  8-node pipeline    │     │                      │
│  Supabase + pgvector│     │  Swarm patterns      │
│  RAPTOR             │◀────│  Progressive         │
│                     │     │  disclosure          │
└─────────────────────┘     │  3-tier routing      │
         ▲                  └─────────────────────┘
         │                           ▲
         │   Evolved skills          │ Patterns
         │   feed into               │ inform
         │                           │
┌────────┴────────────────────────────┴────────────┐
│                  VERSAILLES                       │
│         Skill Discovery & Evolution               │
└───────────────────────────────────────────────────┘
```

**Versailles → Foundation-layer:** Evolved skills can be exported as knowledge ingestion tools for the Foundation-layer pipeline.

**MUNCH → Versailles:** The swarm orchestration patterns, 3-tier routing, and progressive disclosure in CLAUDE.md are directly inspired by the MUNCH-CONTEXT-PROTOCOL-MCP- architecture.

---

*Updated: 2026-03-19 | See also: README.md, harness/HARNESS_ENGINEERING.md*
