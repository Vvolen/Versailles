# SEARCH_DIRECTIVES.md — What Versailles Is Hunting For

> This document defines the **search primitives** — the types of things Versailles
> agents should actively discover, create, and curate. It gives the Scout and other
> agents clear direction on what to bring in and what to ignore.

---

## Two Tracks, Two Purposes

Versailles searches for two fundamentally different things:

### Track 1: Agent Skills (→ `skills/`)
**What:** SKILL.md files that teach agents how to do specific tasks better.
**Pipeline:** Discovered → Bouncer → Evaluator → Evolver (full self-evolution).
**Goal:** Build a library of production-ready, A/B-tested agent instructions
that measurably outperform raw Claude.

### Track 2: Open Source Projects (→ `projects/`)
**What:** GitHub repos, tools, libraries, and frameworks that are useful for
agent-powered development and orchestration.
**Pipeline:** Discovered → Vetted → Cataloged (no evolution — projects are external).
**Goal:** Build a curated catalog of best-in-class tools for the agentic ecosystem.

---

## Skill Search Directives

### Priority Skill Categories

These are the kinds of agent skills Versailles should actively seek out and create.
Ordered by priority for the owner's needs:

#### 1. Agent Orchestration & Workflow Skills
Skills that make agents better at coordinating multi-agent work, managing swarms,
routing between models, and self-organizing.
- Swarm coordination patterns
- Model routing and tier selection
- Task decomposition and delegation
- Agent-to-agent handoff protocols

#### 2. Code Quality & Security Skills
Skills that improve code review, security analysis, and development practices.
- Security vulnerability scanning (OWASP, dependency audit)
- Code review with actionable feedback
- Architecture decision records (ADRs)
- Test generation and TDD patterns

#### 3. Research & Knowledge Synthesis Skills
Skills that make agents better at deep research, knowledge extraction, and
connecting ideas across domains.
- Recursive research with progressive deepening
- Source evaluation and credibility scoring
- Knowledge graph construction
- Cross-domain insight synthesis

#### 4. Repository Management Skills
Skills for maintaining, documenting, and evolving repositories autonomously.
- README and documentation generation
- Issue triage and labeling
- PR review and merge decisions
- Changelog and release note generation

#### 5. Prompt Engineering & Self-Improvement Skills
Skills that make agents better at writing prompts, creating other skills,
and improving their own instructions.
- Skill authoring (meta-skill)
- Prompt optimization and compression
- Self-evaluation and scoring
- Context window management

### Skill Search Queries

When the Scout searches GitHub, use these queries to find skills specifically:

```
"SKILL.md" in:path                                    # Direct SKILL.md files
"agent skill" in:name,description stars:>10            # Repos packaging agent skills
topic:agent-skills                                     # Tagged with agent-skills topic
"---\nname:" "description:" in:file path:SKILL.md      # YAML frontmatter pattern
org:anthropics path:skills                             # Official Anthropic skills
```

### Skill Creation Directives

When no suitable existing skill is found, the Scout or Researcher should **draft** a
new skill in `skills/discovered/`. A drafted skill should:

1. Follow the SKILL.md format (see `SKILL_SPEC.md`)
2. Include at least 3 concrete examples
3. Define clear trigger conditions ("Use when...")
4. Be specific enough to A/B test meaningfully
5. Target one of the priority categories above

---

## Project Search Directives

### Priority Project Categories

These are the kinds of open source projects Versailles should track:

#### 1. Agent Orchestration Frameworks
Multi-agent coordination tools, swarm managers, and workflow engines.
- **Example:** `ruvnet/ruflo` (claude-flow) — swarm orchestration with model routing,
  memory systems, and 60+ agent types
- **Example:** `github/gh-aw` — natural language → GitHub Actions compilation

#### 2. MCP Servers & Integrations
Model Context Protocol servers that extend agent capabilities.
- **Example:** `modelcontextprotocol/servers` — official MCP reference implementations
- Look for: filesystem, database, API, memory, and search servers

#### 3. AI Development Tools
Tools that improve the AI-powered development workflow.
- Code generation assistants
- Testing frameworks for AI outputs
- Evaluation harnesses and benchmarks
- Prompt management systems

#### 4. Security & Guardrails
Tools that make agent operations safer and more controllable.
- Agent firewalls and network isolation
- Permission management for AI actions
- Audit logging and compliance tools
- Input/output sanitization

#### 5. Knowledge & Memory Systems
Tools for persistent agent memory, knowledge graphs, and retrieval.
- Vector databases and embedding tools
- Knowledge graph builders
- RAG (Retrieval Augmented Generation) frameworks
- Persistent memory servers

### Project Search Queries

```
"multi-agent" orchestration in:name,description stars:>50     # Orchestration tools
"model context protocol" server in:name,description           # MCP servers
claude agent tool in:name,description stars:>20               # Claude ecosystem
"agent framework" in:name,description language:python,typescript stars:>100
topic:mcp-server OR topic:agent-framework                    # Tagged repos
```

---

## Owner Preferences (Bespoke Curation)

Versailles is curated for a specific use case. The owner's priorities are:

1. **Non-developer operation** — Everything must work from GitHub's web UI. Prefer tools
   with GUI/web interfaces or that integrate with GitHub Actions.
2. **Self-building repos** — Prioritize tools that enable repositories to update and
   improve themselves autonomously (like gh-aw).
3. **Multi-agent orchestration** — The owner uses claude-flow/RuFlo for swarm
   coordination. Prioritize tools that work with or complement this stack.
4. **Progressive disclosure** — Prefer tools that load context incrementally rather
   than dumping everything at once.
5. **Security-first** — Zero-trust by default. Every external tool is suspect until
   proven otherwise.

### Tools the Owner Already Uses

These are known-good tools in the owner's ecosystem. New discoveries should
complement, not duplicate, these:

| Tool | Purpose | Repo |
|------|---------|------|
| RuFlo (claude-flow) | Multi-agent orchestration, swarm management | `ruvnet/ruflo` |
| GitHub Agentic Workflows | Natural language → GitHub Actions | `github/gh-aw` |
| MCP Filesystem Server | Safe file read/write | `modelcontextprotocol/servers` |
| MCP GitHub Server | GitHub API access | `modelcontextprotocol/servers` |
| MCP Sequential Thinking | Step-by-step reasoning | `modelcontextprotocol/servers` |
| Context7 | Library documentation lookup | `@upstash/context7-mcp` |

---

## How This File Is Used

- **Scout workflow** reads this file to determine search queries and priorities
- **Researcher agent** uses the priority categories to focus deep research
- **Human operator** updates this file to shift priorities as needs change
- **Bouncer** uses the owner preferences to contextualize security decisions

---

*Updated: 2026-03-26 | Read by: Scout, Researcher, Bouncer*
