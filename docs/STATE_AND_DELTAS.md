# State & Deltas — Versailles System Status

> **For agents:** Load this file when you need to understand the current state of Versailles,
> what changed recently, and what work remains. ~1,200 tokens.
> **For humans:** Quick-reference on where the project stands and how to connect the three repos.

---

## 1. What Versailles Is

Versailles is an **autonomous skill discovery and evolution engine** built entirely on GitHub infrastructure.

**The genome metaphor:**
- `skills/` = genome (atomic skill instructions)
- Agent pipelines = gene expression (Scout → Bouncer → Evaluator → Evolver)
- `skills/evolved/` = production-ready phenotype (skills that beat the Claude baseline)
- Evolver mutations = natural selection pressure

**It does NOT:**
- Run code (skills are markdown instruction files, not code)
- Need a database (catalog is flat JSON; memory is git history)
- Require a local machine (everything runs in GitHub Actions or Codespaces)

---

## 2. Current State (as of 2026-04-03)

### Agent Pipeline

| Stage | Count | Files |
|-------|-------|-------|
| `skills/discovered/` | 0 | (empty — last Scout run cleared it) |
| `skills/quarantine/` | 3 | `agent-orchestration-patterns-*`, `deep-code-security-review-*`, `skill-architect-meta-skill-*` |
| `skills/evaluated/` | 1 | `recursive-research-synthesis-2026-04-02-v1.md` |
| `skills/evolved/` | 0 | (none yet — Evaluator has not been triggered on the evaluated skill) |
| `projects/discovered/` | 3 | `anthropic-cookbook-*`, `gh-aw-*`, `mcp-servers-official-*` |
| `projects/vetted/` | 0 | (Bouncer has not been run on projects track yet) |

### Active Workflows (8 total)

| Workflow | Schedule | Last Status |
|----------|----------|-------------|
| `scout.yml` | Every 6h | ✅ Running — routes discoveries correctly |
| `explorer.yml` | Weekly Mon 3 AM | ✅ Added 2026-03-26 — deep gem hunting |
| `bouncer.yml` | On push to discovered/ | ✅ Running — quarantined 3 skills |
| `eval.yml` | On push to evaluated/ | ⚠️ Pending trigger — 1 skill waiting |
| `evolve.yml` | Daily 2 AM | ⚠️ Nothing to evolve yet (no evolved/ skills) |
| `research.yml` | Issue label: research-request | ✅ Functional |
| `self-heal.yml` | Every push | ✅ Running — validates repo integrity |
| `agentic-planner.yml` | Manual (workflow_dispatch) | ✅ Added 2026-04-03 — spec/task/test generation |

### Catalog

| Catalog | Entries | Last Updated |
|---------|---------|-------------|
| `catalog/tools.json` | varies | Updated each Scout run |
| `catalog/mcps.json` | — | Pending population |
| `catalog/plugins.json` | — | Pending population |

### Environment Setup

- ✅ `.devcontainer/devcontainer.json` — one-click Codespaces environment
- ✅ `harness/agent-bootstrap.sh` — pre-flight verification script
- ✅ `.claude/settings.json` — Claude Code / agent runtime config
- ✅ `.mcp.json` — MCP server configuration
- ✅ `harness/mcp-gateway.json` — role-based MCP access control

---

## 3. Delta: What Changed (Last ~2 Weeks)

> **Reference date:** ~2026-03-19 → 2026-04-03

### Added

| Item | What It Does |
|------|-------------|
| **Explorer agent** (`agents/explorer/`, `explorer.yml`) | Deep gem hunter; weekly cron; 6-dimension scoring rubric; self-building feedback loop |
| **Projects track** (`projects/discovered/`, `projects/vetted/`) | Separate pipeline for open-source repos (not skills); Scout now routes correctly |
| **Scout routing fix** | `scout.yml` now sends SKILL.md repos → `skills/discovered/`, everything else → `projects/discovered/` |
| **3 projects discovered** | `anthropic-cookbook`, `gh-aw`, `mcp-servers-official` |
| **Cross-agent journal** (`AGENT_NOTES.md`) | Append-only memory for agent-to-agent communication across workflow runs |
| **6 documentation files** | `docs/GETTING_STARTED.md`, `ARCHITECTURE.md`, `DELEGATION_PLAYBOOK.md`, `GITHUB_ACTIONS_GUIDE.md`, `POWER_USER_PATTERNS.md`, `CODESPACES_GUIDE.md` |
| **Power-up modules** | `harness/power-ups/context-forking.md`, `progressive-disclosure.md`, `swarm-orchestration.md` |
| **HARNESS_ENGINEERING.md** | 7-layer harness stack philosophy |
| **MCP gateway** (`harness/mcp-gateway.json`) | Role-based tool access control |
| **5 agent SOUL.md files** | Identity files for Scout, Bouncer, Evaluator, Evolver, Explorer |
| **3 Issue templates** | Research request, skill discovery, skill evolution |
| **`.claude/` directory** | Claude Code / agent runtime project configuration |
| **Agentic planner workflow** | `workflow_dispatch` spec/task/test generation pipeline |

### Fixed

| Item | Fix |
|------|-----|
| Scout routing bug | Skills and projects now go to correct directories |
| Bouncer false-positive quarantine | Note: bouncer flags words like "token(s)" — see SECURITY_CHECKS.md for known issue |

### Not Changed

- `CLAUDE.md` (constitution) — still v1.0.0 from 2026-03-19
- Core skill evolution logic (Evaluator, Evolver) — unchanged
- Catalog JSON schema — unchanged

---

## 4. What's Still Missing (Gaps to Close)

These items are known gaps between the current state and a fully operational system:

### High Priority

| Gap | Impact | How to Fix |
|-----|--------|-----------|
| **Evaluator not triggered** | The 1 skill in `evaluated/` has never been A/B tested | Manually trigger `eval.yml` workflow on the skill |
| **Quarantine review** | 3 skills stuck in quarantine | Human reviews each; remediate or promote with override |
| **`catalog/mcps.json` empty** | MCP discovery track not populated | Run Scout with MCP-focused search terms |

### Medium Priority

| Gap | Impact | How to Fix |
|-----|--------|-----------|
| **No META_INDEX** | Agents must scan all files; no progressive disclosure index | Create `META_INDEX.md` at root with one-line per file |
| **Ruflo not used in workflows** | Orchestration benefit unrealized; workflows use embedded Python instead | Optionally migrate key workflows to use `ruflo swarm` |
| **No memory store (Supabase)** | Skills are stored in git only; no vector search, no semantic retrieval | Deploy schema from Foundation-layer to Supabase; wire up pgvector |
| **`catalog/plugins.json` empty** | Plugin discovery track not populated | Extend Scout to search GitHub Marketplace and npm |

### Low Priority (Future)

| Gap | Impact |
|-----|--------|
| No RAPTOR tree | Hierarchical knowledge compression not implemented |
| No cross-repo artifact exchange | Evolved skills not yet fed to Foundation-layer |
| Self-healing is passive | Self-heal workflow validates but doesn't auto-fix |

---

## 5. How to Connect Versailles ↔ Foundation-layer ↔ MUNCH

### Recommendation: Per-Repo Environments, GitHub Actions as Fabric

**Do NOT share a single Codespace or environment across all three repos.** Here is why:
- Each repo has a different primary language/runtime (Python in Foundation-layer, Node/shell in Versailles)
- Each repo has different secrets requirements
- Environment bleed causes mysterious failures

**Do:** Treat each repo as an independent deployable unit with its own `.devcontainer/` and secrets.

### Integration Architecture

```
┌─────────────────────┐        ┌──────────────────────┐
│   Foundation-layer  │        │  MUNCH-CONTEXT-       │
│   (8-node pipeline) │        │  PROTOCOL-MCP-        │
│                     │        │  (Ruflo + MCP harness)│
│  Accepts: skill     │        │                       │
│  documents as input │        │  Provides: swarm      │
│  sources            │        │  patterns, 3-tier     │
└─────────┬───────────┘        │  routing templates    │
          │  ↑ Evolved          └──────────┬────────────┘
          │  skill artifacts               │ ↑ Copy patterns
          │                               │   (no live link)
          └──────────────────────────────→│
                     VERSAILLES           │
               (Skill discovery/          │
                evolution engine)         │
```

### Concrete Integration Steps

#### Versailles → Foundation-layer (one-way skill export)

```yaml
# In Versailles .github/workflows/evolve.yml (add this step after evolution)
- name: Export evolved skill to Foundation-layer
  if: steps.evolve.outputs.promoted == 'true'
  uses: peter-evans/repository-dispatch@v3
  with:
    token: ${{ secrets.CROSS_REPO_TOKEN }}
    repository: Vvolen/Foundation-layer
    event-type: skill-evolved
    client-payload: |
      {
        "skill_file": "${{ steps.evolve.outputs.skill_path }}",
        "skill_name": "${{ steps.evolve.outputs.skill_name }}",
        "score": "${{ steps.evolve.outputs.score }}"
      }
```

Foundation-layer then listens for `skill-evolved` events and ingests the skill document through its Node 1 pipeline.

#### MUNCH → Versailles (pattern reuse, no live coupling)

Do not create a runtime dependency on MUNCH. Instead:
1. When MUNCH patterns are updated, copy relevant sections to `harness/power-ups/`
2. Update `harness/mcp-gateway.json` with any new role/tool assignments
3. Update `CLAUDE.md` if the 3-tier routing rules change

This is intentionally a **copy, not a reference** — decoupled for reproducibility.

#### GitHub Actions as Integration Fabric

```
Versailles workflow     →  repository_dispatch  →  Foundation-layer workflow
Foundation-layer        →  artifact upload      →  Versailles research input
MUNCH patterns          →  manual copy          →  harness/power-ups/
```

**Secrets required for cross-repo dispatch:**
- Create a fine-grained PAT with `contents:write` + `actions:write` on Foundation-layer
- Store as `CROSS_REPO_TOKEN` in Versailles repo secrets

---

## 6. Running Ruflo in Versailles (2 Workers + Orchestrator)

Ruflo (formerly claude-flow) is pre-installed in the Codespaces environment.

### Standard Versailles Swarm Pattern

```bash
# Launch from Codespaces terminal
ruflo swarm start \
  --orchestrator claude-sonnet \
  --workers 2 \
  --task "your task description" \
  --context CLAUDE.md \
  --max-agents 5

# Equivalent using legacy alias:
claude-flow swarm start \
  --orchestrator claude-sonnet \
  --workers 2 \
  --task "your task description"
```

### Example: Discover + Vet in Parallel

```bash
# Worker 1: Scout MCP servers
# Worker 2: Scout Claude skills
# Orchestrator: Merge and score results

ruflo swarm start \
  --orchestrator claude-sonnet \
  --workers 2 \
  --task "Discover and score the top 5 new MCP servers and top 5 new Claude skills from GitHub this week. Worker 1 handles MCPs, Worker 2 handles skills. Merge results into catalog/mcps.json." \
  --context CLAUDE.md \
  --context agents/scout/SOUL.md \
  --max-agents 5 \
  --output catalog/
```

### Swarm Rules (from CLAUDE.md)

- Max 5 concurrent agents
- Max 2 nesting levels (orchestrator → specialists only; specialists cannot spawn)
- Agent timeout: 30 minutes
- All outputs must use unique, predictable paths (`tmp/agent-{id}-results.json`)
- Emit `COMPLETE` signal when done — orchestrator will not trust silent agents

---

*Updated: 2026-04-03 | See also: docs/ARCHITECTURE.md, harness/HARNESS_ENGINEERING.md, AGENT_NOTES.md*
