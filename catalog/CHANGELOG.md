# Versailles Catalog Changelog

> Every agent action is recorded here. This is the audit trail for the entire system.
> Format: `## YYYY-MM-DD — [Agent] Run` followed by bullet points.

---

## 2026-03-19 — Repository Initialized

- 🏰 Versailles repository created
- 📁 Complete directory structure scaffolded
- 🤖 4 agents initialized: Scout, Bouncer, Evaluator, Evolver
- 📋 6 workflows configured: scout, bouncer, eval, evolve, research, self-heal
- 📚 Documentation complete
- ✅ Ready for first Scout run

---

## 2026-03-26 — Manual Scout (Agent Session)

- 📝 Created `AGENT_NOTES.md` — cross-agent memory journal (pattern from Foundation-layer)
- 🔭 Discovered 3 tools manually:
  - `gh-aw-agentic-workflows` (score: 92) — GitHub Agentic Workflows by github org
  - `mcp-servers-official` (score: 88) — Official MCP server collection by modelcontextprotocol
  - `anthropic-cookbook` (score: 85) — Claude recipes and patterns by anthropics
- 📋 Updated catalog/tools.json with new entries
- 🔗 Researched github/gh-aw integration potential for natural language workflows
- 💾 Stored key repository facts in agent memory system

---

## 2026-03-26 — Skills vs Projects Restructuring (Agent Session)

- 🏗️ Created `projects/` directory tree (`discovered/`, `vetted/`, `archive/`)
- 📦 Moved 3 tool discoveries from `skills/discovered/` → `projects/discovered/`
  - These are open source projects, NOT agent skills (SKILL.md)
- 📋 Created `SKILL_SPEC.md` — defines what agent skills ARE (Anthropic SKILL.md spec)
- 🎯 Created `SEARCH_DIRECTIVES.md` — formal search primitives and owner preferences
- ✏️ Updated `CLAUDE.md` sections 6 + 8 to reflect two-track pipeline
- ✏️ Updated `README.md` architecture and directory structure
- ✏️ Updated `self-heal.yml` and `agent-bootstrap.sh` for new dirs
- 🔬 Researched RuFlo (ruvnet/ruflo) — confirmed as claude-flow V3
- 🔬 Researched Anthropic Agent Skills spec (agentskills.io/specification)

---

<!-- Agent entries will be appended below this line -->

## 2026-04-02 — Explorer Agent & Pipeline Seeding (Agent Session)

- 🧭 Created **Explorer Agent** — the strategic gem hunter (5th agent)
  - `agents/explorer/SOUL.md` — Identity, mission, values, output format
  - `agents/explorer/EXPLORATION_METHODOLOGY.md` — 5-phase cycle, 6-dimension scoring, self-building loop
- 🔧 Created **Explorer Workflow** (`.github/workflows/explorer.yml`)
  - Weekly cron (Mondays 3 AM UTC) + manual trigger
  - Full 5-phase methodology: intelligence gathering → deep research → gem scoring → strategic decision → report
  - Routes skills vs projects correctly
- 🔧 Fixed **Scout routing bug** in `.github/workflows/scout.yml`
  - Scout now routes projects to `projects/discovered/` instead of `skills/discovered/`
  - Added `is_skill()` function checking for SKILL.md files and Claude Skill category
  - Added 3 SKILL.md-specific search queries from SEARCH_DIRECTIVES.md
- 📝 Created **4 production-quality agent skills** (first real content in pipeline!):
  - `skills/quarantine/deep-code-security-review-2026-04-02-quarantine.md` — OWASP Top 10 code review skill
  - `skills/evaluated/recursive-research-synthesis-2026-04-02-v1.md` — Multi-layer research with synthesis
  - `skills/quarantine/skill-architect-meta-skill-2026-04-02-quarantine.md` — Meta-skill for creating agent skills
  - `skills/quarantine/agent-orchestration-patterns-2026-04-02-quarantine.md` — 5 multi-agent orchestration patterns
- ✏️ Updated `self-heal.yml` to validate Explorer agent directory and SOUL.md
- ✏️ Updated `README.md` — architecture diagram, agent table, directory structure, badges
- ✏️ Updated `AGENT_NOTES.md` — Entry 3 with session insights


## 2026-04-03 — Bouncer Run
- ❌ `skill-architect-meta-skill-2026-04-02-quarantine.md` quarantined (score: 20) — human review required
- ❌ `deep-code-security-review-2026-04-02-quarantine.md` quarantined (score: 0) — human review required
- ✅ `recursive-research-synthesis-2026-04-02-v1.md` passed bouncer (score: 50)
- ❌ `agent-orchestration-patterns-2026-04-02-quarantine.md` quarantined (score: 20) — human review required

---

## 2026-04-03 — Harness Environment Standardization (Agent Session)

- 📁 Created `.claude/settings.json` — Claude Code / agent runtime project configuration (MCP servers, tier routing, permissions)
- 📁 Created `.claude/context.md` — Compact project context for agent cold-starts (~600 tokens)
- 🔧 Updated `.devcontainer/devcontainer.json` — Ruflo version health-check in postCreateCommand; swarm command hint in postStartCommand
- 🔧 Updated `harness/agent-bootstrap.sh` — Step 5 now detects `ruflo` binary (with `claude-flow` fallback); prints 2-worker + orchestrator swarm command
- 📄 Created `docs/STATE_AND_DELTAS.md` — State/delta document: current pipeline status, 2-week changelog, gap analysis, repo-connection guide, Ruflo swarm patterns
- ⚡ Created `.github/workflows/agentic-planner.yml` — workflow_dispatch: prompt → spec.md + task_plan.md + test_plan.md as artifacts; optional branch commit and issue creation; no auto-merge
- 📝 Updated `AGENT_NOTES.md` — Entry 4 with session insights and handoff notes
