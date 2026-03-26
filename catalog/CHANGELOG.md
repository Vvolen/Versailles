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
