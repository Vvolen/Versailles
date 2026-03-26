# SKILL_SPEC.md — What Agent Skills Are in Versailles

> Skills are **not** open source projects, GitHub repos, or tool links.
> Skills are **agent instructions** — self-contained packages that make AI agents
> measurably better at specific tasks. They follow the open
> [Agent Skills specification](https://agentskills.io/specification) created by Anthropic.

---

## What Is an Agent Skill?

A skill is a folder containing a `SKILL.md` file with:
1. **YAML frontmatter** — metadata (name, description)
2. **Markdown body** — detailed instructions, examples, and guidelines

When loaded, a skill becomes part of the agent's system prompt. It teaches the agent
*how* to do a specific task better than it would without the skill.

### Minimal SKILL.md Template

```markdown
---
name: my-skill-name
description: What this skill does and when to use it. Use when [trigger context].
---

# My Skill Name

## Instructions
[Detailed step-by-step instructions the agent should follow]

## Examples
- Example usage 1
- Example usage 2

## Guidelines
- Guideline 1
- Guideline 2
```

### Required Frontmatter Fields

| Field | Rules |
|-------|-------|
| `name` | 1–64 chars, lowercase, alphanumeric + hyphens only. Must match folder name. |
| `description` | 1–1024 chars. Describe what it does AND when to use it ("Use when..."). |

### Optional Frontmatter Fields

| Field | Purpose |
|-------|---------|
| `license` | License name (e.g., `MIT`, `Apache-2.0`) |
| `compatibility` | Platform/environment requirements |
| `metadata` | Arbitrary key-value pairs (author, version, etc.) |

---

## The Versailles Skill Pipeline

Skills go through a discovery → vetting → testing → evolution lifecycle:

```
  skills/discovered/          ← Scout finds or creates skill drafts
        ↓
  [Bouncer runs security check]
        ↓
  skills/quarantine/          ← Failed security → human review
        OR
  skills/evaluated/           ← Passed security → ready for A/B testing
        ↓
  [Evaluator runs blind A/B test vs Claude baseline]
        ↓
  skills/evolved/             ← Beat baseline by ≥15% → production
        OR
  skills/archive/             ← Failed eval → archived
        ↓
  [Evolver runs TDD mutation cycles]
        ↓
  skills/evolved/ v2, v3...   ← Each generation gets better
```

### Skill File Naming

```
skills/discovered/<skill-name>-<YYYY-MM-DD>.md     # Scout creates these
skills/quarantine/<skill-name>-quarantine.md        # Bouncer stages here
skills/evaluated/<skill-name>-v<N>.md               # Ready for evolution
skills/evolved/<skill-name>-v<N>-evolved.md         # Production skills
skills/archive/<skill-name>-deprecated-<date>.md    # Never delete, archive
```

### What Makes a Skill "Good"?

A skill should:
- **Improve measurable output** — A/B testing must show ≥15% improvement over raw Claude
- **Be specific** — "Write better code" is not a skill. "Review Python code for security
  vulnerabilities using OWASP Top 10" is a skill.
- **Include examples** — Show the agent what good output looks like
- **Define triggers** — When should this skill activate? ("Use when asked to...")
- **Be self-contained** — All instructions in one file, no external dependencies

---

## Skills vs Projects — The Critical Distinction

| | Agent Skills (skills/) | Open Source Projects (projects/) |
|---|---|---|
| **What** | Instructions that make agents better | GitHub repos, tools, libraries |
| **Format** | SKILL.md with YAML frontmatter | Discovery markdown (repo metadata) |
| **Pipeline** | Discovered → Bouncer → Eval → Evolve | Discovered → Vetted → Cataloged |
| **Evolution** | Yes — TDD mutation cycles improve them | No — projects are what they are |
| **A/B Testing** | Yes — blind test vs Claude baseline | No — not applicable |
| **Stored in** | `skills/` directory tree | `projects/` directory tree |
| **Example** | "How to review code for security issues" | github/gh-aw, ruvnet/ruflo |

---

## Reference Implementations

See these for examples of well-built skills:

- **Anthropic's official skills:** https://github.com/anthropics/skills
  - `mcp-builder` — teaches Claude to build MCP servers
  - `webapp-testing` — teaches Claude to test web applications
  - `skill-creator` — teaches Claude to create new skills (meta!)
  - `frontend-design` — teaches Claude frontend design patterns

- **Agent Skills specification:** https://agentskills.io/specification

---

*Used by: Scout, Evaluator, Evolver | Updated: 2026-03-26*
