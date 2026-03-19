# 🏰 Versailles

**A self-evolving skills & tool discovery engine, operated entirely from GitHub.**

> You are the architect. Agents are the builders. Issues are the blueprints.

[![Scout](https://github.com/Vvolen/Versailles/actions/workflows/scout.yml/badge.svg)](https://github.com/Vvolen/Versailles/actions/workflows/scout.yml)
[![Bouncer](https://github.com/Vvolen/Versailles/actions/workflows/bouncer.yml/badge.svg)](https://github.com/Vvolen/Versailles/actions/workflows/bouncer.yml)
[![Self-Heal](https://github.com/Vvolen/Versailles/actions/workflows/self-heal.yml/badge.svg)](https://github.com/Vvolen/Versailles/actions/workflows/self-heal.yml)

---

## What Is Versailles?

Versailles is an **autonomous orchestration layer** that continuously discovers, vets, tests, and evolves AI tools and skills — without you writing a single line of code. You operate it from GitHub's web interface: create an Issue, and agents go to work.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         VERSAILLES                                  │
│                                                                     │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────────┐  │
│  │  SCOUT   │───▶│ BOUNCER  │───▶│EVALUATOR │───▶│   EVOLVER    │  │
│  │          │    │          │    │          │    │              │  │
│  │ Discovers│    │ Security │    │  A/B     │    │  TDD loop    │  │
│  │ tools on │    │ vets     │    │  tests   │    │  mutates &   │  │
│  │ GitHub   │    │ skills   │    │  skills  │    │  improves    │  │
│  └──────────┘    └──────────┘    └──────────┘    └──────────────┘  │
│       │               │               │                │           │
│       ▼               ▼               ▼                ▼           │
│  discovered/     quarantine/     evaluated/        evolved/        │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    SKILL PIPELINE                           │   │
│  │  discovered → quarantine → evaluated → evolved → archive   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌───────────────────┐    ┌──────────────────────────────────────┐ │
│  │   RESEARCHER      │    │           SELF-HEALER                │ │
│  │ Triggered by      │    │ Validates repo on every push:        │ │
│  │ Issues → Finds    │    │ secrets, JSON, structure, skills     │ │
│  │ deep knowledge    │    └──────────────────────────────────────┘ │
│  └───────────────────┘                                             │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  HARNESS: CLAUDE.md + .mcp.json + agent-bootstrap.sh       │   │
│  │  3-tier routing · swarm orchestration · context forking    │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

---

## The Four Agents

| Agent | Schedule | What It Does |
|-------|----------|-------------|
| 🔭 **Scout** | Every 6 hours | Searches GitHub for MCP servers, Claude skills, AI agents, plugins. Scores each on 5 dimensions. |
| 🛡️ **Bouncer** | On every discovery | Zero-trust security vetting. 37% of published AI skills are malicious. Bouncer catches them. |
| 🧪 **Evaluator** | On vetted skills | Blind A/B tests against raw Claude baseline. Promotes skills that beat the benchmark by 15%+. |
| �� **Evolver** | Daily | TDD mutation loop. Generates test scenarios, mutates skill instructions, keeps improvements. |

Plus:
- 🔬 **Researcher** — Triggered by Issues labeled `research-request`. Recursively deepens knowledge on a topic.
- 🏥 **Self-Healer** — Runs on every push. Validates structure, scans for secrets, checks JSON integrity.

---

## Getting Started (No Code Required)

### Step 1: Open Codespaces
Click the green **Code** button → **Codespaces** → **Create codespace on main**

Your full agentic environment launches automatically with Node.js 22, Python 3.11, claude-flow, and all MCP tools pre-installed.

### Step 2: Set Your Secrets
Go to **Settings → Secrets and variables → Actions** and add:
- `ANTHROPIC_API_KEY` — Your Anthropic API key
- `GITHUB_TOKEN` — Already provided automatically by GitHub

### Step 3: Trigger an Agent
- **Discover tools:** Go to **Actions → Scout → Run workflow**
- **Research a topic:** Create an Issue using the **Research Request** template
- **Evolve a skill:** Create an Issue using the **Skill Evolution** template

### Step 4: Watch It Work
Go to **Actions** tab → click any running workflow → watch the live logs.

---

## Directory Structure

```
Versailles/
├── CLAUDE.md                    # Agent harness constitution — agents read this first
├── .mcp.json                    # MCP server configuration
├── .devcontainer/               # Codespaces configuration
├── .github/
│   ├── copilot-instructions.md  # Instructions for Copilot coding agent
│   ├── ISSUE_TEMPLATE/          # Structured issue templates
│   └── workflows/               # All 6 GitHub Actions workflows
├── agents/                      # Agent identity and methodology files
│   ├── scout/                   # SOUL.md + CRITERIA.md
│   ├── bouncer/                 # SOUL.md + SECURITY_CHECKS.md
│   ├── evaluator/               # SOUL.md + EVAL_FRAMEWORK.md
│   └── evolver/                 # SOUL.md + EVOLUTION_RULES.md
├── skills/
│   ├── discovered/              # Raw scout output (pre-security)
│   ├── quarantine/              # Under security review
│   ├── evaluated/               # Passed security, being tested
│   ├── evolved/                 # Production-ready, TDD-improved
│   └── archive/                 # Deprecated skills
├── catalog/
│   ├── tools.json               # Rated tool catalog (auto-updated)
│   ├── mcps.json                # MCP server catalog
│   ├── plugins.json             # Plugin catalog
│   └── CHANGELOG.md             # Every agent action logged here
├── research/
│   ├── topics/                  # Research topics
│   ├── findings/                # Completed research reports
│   └── RESEARCH_METHODOLOGY.md
├── harness/
│   ├── HARNESS_ENGINEERING.md   # Environment > model philosophy
│   ├── mcp-gateway.json         # MCP gateway config
│   ├── agent-bootstrap.sh       # Agent startup script
│   └── power-ups/               # Reusable capability modules
└── docs/
    ├── ARCHITECTURE.md
    ├── GETTING_STARTED.md
    ├── GITHUB_ACTIONS_GUIDE.md
    ├── CODESPACES_GUIDE.md
    ├── POWER_USER_PATTERNS.md
    └── DELEGATION_PLAYBOOK.md
```

---

## Related Repositories

- **[Vvolen/Foundation-layer](https://github.com/Vvolen/Foundation-layer)** — NickOS knowledge engine. 8-node ingestion pipeline using Supabase + pgvector. Versailles feeds evolved skills into Foundation-layer.
- **[Vvolen/MUNCH-CONTEXT-PROTOCOL-MCP-](https://github.com/Vvolen/MUNCH-CONTEXT-PROTOCOL-MCP-)** — Agent power-up harness built on RuFlo V3. The swarm orchestration patterns in CLAUDE.md come from here.

---

## Documentation

| Doc | Audience | What It Covers |
|-----|----------|---------------|
| [Getting Started](docs/GETTING_STARTED.md) | Everyone | How to operate Versailles from GitHub's web UI |
| [GitHub Actions Guide](docs/GITHUB_ACTIONS_GUIDE.md) | Non-developers | What YAML is, how crons work, how secrets work |
| [Codespaces Guide](docs/CODESPACES_GUIDE.md) | Everyone | How to use Codespaces as your agentic environment |
| [Architecture](docs/ARCHITECTURE.md) | Technical | Full system design and data flow |
| [Harness Engineering](harness/HARNESS_ENGINEERING.md) | Builders | Why environment > model, how to compose harnesses |
| [Power User Patterns](docs/POWER_USER_PATTERNS.md) | Advanced | March 2026 patterns: claude-flow, MCPC, SkillFish, Context7 |
| [Delegation Playbook](docs/DELEGATION_PLAYBOOK.md) | Architects | How to operate as an orchestrator, not a coder |

---

*Built with GitHub Copilot Pro Plus · Powered by Claude · Operated from github.com*
