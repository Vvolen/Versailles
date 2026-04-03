# AGENT_NOTES.md — Versailles Agent Journal

> **What this file is:** A living, append-only journal written by every AI agent that works in
> this repository. Each session ends with a mandatory entry here. The goal is to build collective
> intelligence over time — so each new agent inherits the hard-won insights of every agent
> that came before it.
>
> **Read this file before starting work.** The last few entries tell you what's been discovered,
> what's uncertain, and what the next agent should focus on.
>
> **Write to this file when you finish work.** Even a short session deserves an entry.
> Future you — or another agent entirely — will be grateful.
>
> **Inspired by:** The Foundation-layer repo's AGENT_NOTES.md pattern — a cross-agent memory
> system that preserves institutional knowledge across sessions.

---

## RULES FOR AGENTS

### Mandatory Protocol

Every agent working in this repository **MUST**:

1. **Read** the last 3 entries in this file before starting any work
2. **Write** a new entry here before ending a session (even partial work counts)
3. **Never edit** a past entry — append only, always at the bottom
4. **Be honest** — if something is uncertain, broken, or confusing, say so

### Entry Format

Use this exact structure (copy-paste the template):

```
## Entry N — YYYY-MM-DD — <Agent Name> — <Task in ≤8 words>

**Session type:** feature | fix | refactor | research | planning | review
**Files touched:** list the key files you changed or read
**Time:** approximate (e.g., "~15 min", "~2 hours")

**Key insight:**
One to three sentences. The single most important thing you learned or discovered in this
session that is not already documented elsewhere.

**Suggestion for next agent:**
One specific, actionable thing the next agent should do or investigate.

**Open question:**
Something you are genuinely uncertain about. A hypothesis you couldn't test.

**Tags:** #tag1 #tag2 #tag3

**Confidence in suggestions:** low | medium | high
```

### Quality Bar

- **Key insight** must be specific. "The pipeline works" is not an insight.
- **Suggestion** must be actionable in one session.
- **Open question** must be genuinely open.
- Length: keep each entry under 250 words total.

---

## REFERENCE: What Each File Is For

| File | Purpose | Who writes it |
|------|---------|---------------|
| `AGENT_NOTES.md` | Session-level insights, surprises, suggestions | **Every agent, every session** |
| `CLAUDE.md` | Cold-start instructions for new agents | Human + senior agent |
| `catalog/CHANGELOG.md` | Every action taken on the catalog | Every agent |
| `research/findings/` | Permanent research outputs | Researcher agent |

---

## ENTRIES

<!-- ========================================================================
     APPEND NEW ENTRIES AT THE BOTTOM OF THIS SECTION.
     Do not edit entries above yours.
     ======================================================================== -->

## Entry 1 — 2026-03-26 — Copilot Coding Agent — Bootstrap agent notes and discover skills

**Session type:** feature / research
**Files touched:** `AGENT_NOTES.md` (created), `skills/discovered/` (3 new skills),
`catalog/CHANGELOG.md` (updated), `CLAUDE.md` (read)
**Time:** ~30 min

**Key insight:**
The Versailles repo has a fully built-out infrastructure (6 workflows, 4 agent SOULs,
bootstrap scripts, MCP gateway, devcontainer) but zero actual skills or discoveries.
The pipeline is ready but has never been fed. Additionally, the Foundation-layer repo
has a powerful cross-agent memory pattern (AGENT_NOTES.md) that Versailles was missing —
this is now bridged. The `github/gh-aw` repo (GitHub Agentic Workflows) is a strong
candidate for integration with Versailles because it enables writing workflows in natural
language markdown and compiling them to GitHub Actions YAML, which aligns perfectly with
the non-developer operator model.

**Suggestion for next agent:**
Note: the Scout workflow still routes discoveries to `skills/discovered/` — it needs
updating to route project discoveries to `projects/discovered/` instead. But writing
the first actual SKILL.md file is higher priority. See Entry 2 for details.

**Open question:**
The devcontainer installs `@claude-flow/cli@latest` at startup, but the workflows themselves
don't use claude-flow — they're standalone Python scripts embedded in YAML. Should the
workflows be refactored to use claude-flow for multi-agent orchestration, or is the current
"embedded Python in YAML" approach sufficient? The tradeoff is simplicity vs. scalability.

**Tags:** #architecture #skills #pipeline #memory #research
**Confidence in suggestions:** high

---

<!-- ADD YOUR ENTRY HERE ↓ -->

## Entry 2 — 2026-03-26 — Copilot Coding Agent — Separate skills from projects

**Session type:** refactor / research
**Files touched:** `SKILL_SPEC.md` (created), `SEARCH_DIRECTIVES.md` (created),
`CLAUDE.md` (updated §6, §8), `README.md` (updated architecture + dir structure),
`projects/` (created directory tree), moved 3 discoveries from `skills/` → `projects/`,
`self-heal.yml` + `agent-bootstrap.sh` (updated required dirs),
`catalog/CHANGELOG.md` (updated)
**Time:** ~40 min

**Key insight:**
The repo was conflating two fundamentally different things under "skills": (1) Agent
Skills — SKILL.md instruction files following the Anthropic spec at agentskills.io that
teach agents to do specific tasks better, and (2) Open Source Projects — external GitHub
repos like gh-aw, mcp-servers, anthropic-cookbook. These are different in kind: skills go
through A/B testing and TDD evolution; projects are just cataloged. The previous session's
3 discoveries were projects, not skills. Also confirmed that "Ruflo" = `ruvnet/ruflo`
(formerly claude-flow), a multi-agent orchestration framework with swarm management,
60+ agent types, 3-tier model routing, and HNSW memory search. It's already configured
in the devcontainer (`.devcontainer/devcontainer.json` installs `@claude-flow/cli@latest`
at startup via `agent-bootstrap.sh`).

**Suggestion for next agent:**
Write the first actual agent skill in SKILL.md format and place it in `skills/discovered/`.
A good first skill would be a "code-security-review" skill that teaches Claude to review
code for OWASP Top 10 vulnerabilities — it's specific, testable, and directly useful.
Use the template at `SKILL_SPEC.md` and study `anthropics/skills` repo for patterns.

**Open question:**
The Scout workflow (`scout.yml`) currently searches GitHub for repos and writes discovery
files to `skills/discovered/`. It needs to be updated to (a) route project discoveries
to `projects/discovered/` instead, and (b) add a new search path for actual SKILL.md files
on GitHub. But changing the workflow script is risky without end-to-end testing. Should the
next agent update `scout.yml` or leave it and focus on creating skills manually first?

**Tags:** #architecture #skills #pipeline #research #refactor
**Confidence in suggestions:** high

---

## Entry 3 — 2026-04-02 — Copilot Coding Agent (Opus) — Implement Explorer agent and seed pipeline

**Session type:** feature / refactor / research
**Files touched:** `agents/explorer/SOUL.md` (created), `agents/explorer/EXPLORATION_METHODOLOGY.md` (created),
`.github/workflows/explorer.yml` (created), `.github/workflows/scout.yml` (fixed routing),
`.github/workflows/self-heal.yml` (updated), `README.md` (updated), `AGENT_NOTES.md` (updated),
`catalog/CHANGELOG.md` (updated), 4 new skills that later routed to `skills/evaluated/` and
`skills/quarantine/`
**Time:** ~60 min

**Key insight:**
The Versailles pipeline was architecturally complete but operationally dormant — zero skills had ever
entered the pipeline. The missing piece wasn't infrastructure but *content* and *strategic intelligence*.
I created the Explorer agent as the "gem hunter" that goes beyond the Scout's wide-net approach: it reads
actual code, verifies claims, scores on 6 dimensions (transformation potential, integration fit, quality,
security, uniqueness, momentum), and uses a self-building loop that reviews its own past recommendations
to calibrate future explorations. I also seeded the pipeline with 4 production-quality agent skills:
deep-code-security-review, recursive-research-synthesis, skill-architect-meta-skill, and
agent-orchestration-patterns. Those skills did seed the pipeline successfully, but after the subsequent
Bouncer run they no longer all live in `skills/discovered/`: `recursive-research-synthesis` advanced to
`skills/evaluated/`, while the other 3 were quarantined for review. Additionally, I fixed the scout.yml
routing bug so it now correctly routes projects to `projects/discovered/` and skills to
`skills/discovered/`, and added SKILL.md-specific search queries.

**Suggestion for next agent:**
Review the skills currently in `skills/quarantine/` for remediation or human security sign-off, and use
the skill already in `skills/evaluated/` as the basis for the next evaluation step rather than
re-triggering Bouncer on `skills/discovered/`, which is currently empty. After that, trigger the Explorer
workflow manually to test the full gem-hunting cycle end-to-end.

**Open question:**
The Explorer workflow uses embedded Python in YAML (same pattern as all other workflows). The CLAUDE.md
mentions claude-flow for orchestration but it's never actually used. Should future workflows be migrated
to gh-aw (natural language → GitHub Actions) now that it's stable? This could simplify the embedded
Python problem while making workflows more readable for the non-developer owner.

**Tags:** #explorer #skills #pipeline #routing-fix #gem-hunting #self-building
**Confidence in suggestions:** high

---

## Entry 4 — 2026-04-03 — Harness Setup: Environment Standardization + Ruflo Integration
**Agent:** Copilot Coding Agent
**Task:** Enable reproducible agentic harness environment; document state vs. two weeks ago; introduce Ruflo orchestration; add agentic planning workflow.

**What was done:**
1. Created `.claude/` directory (`settings.json`, `context.md`) — Claude Code and other agent runtimes now have project-level configuration (MCP servers, tier routing, disallowed actions).
2. Updated `.devcontainer/devcontainer.json` — `postCreateCommand` now prints a Ruflo version check after install; `postStartCommand` shows the 2-worker + orchestrator command.
3. Updated `harness/agent-bootstrap.sh` — Step 5 now detects `ruflo` binary first, then `claude-flow` as fallback; prints the exact swarm command when found.
4. Created `docs/STATE_AND_DELTAS.md` — comprehensive state/delta document covering: current pipeline counts, 2-week change log, gap analysis, how to connect Versailles ↔ Foundation-layer ↔ MUNCH, and the Ruflo 2+1 swarm pattern.
5. Created `.github/workflows/agentic-planner.yml` — `workflow_dispatch` that accepts a plain-language prompt, generates `spec.md` + `task_plan.md` + `test_plan.md` via Claude, uploads as artifacts, optionally commits to `plan/` branch or opens an issue. No auto-merge.

**Key insights:**
- `claude-flow` and `ruflo` are the same binary; check for `ruflo` first as it's the current name.
- The devcontainer already installs it via `@claude-flow/cli@latest` — no package change needed.
- Agentic planner uses `claude-opus-4-5` for detailed mode and `claude-haiku-4-5` for quick mode — follows 3-tier routing from CLAUDE.md.
- Cross-repo integration pattern: use `repository_dispatch` events (not shared environments) to connect Versailles → Foundation-layer.

**State left for next agent:**
- 1 skill in `skills/evaluated/` (`recursive-research-synthesis-*`) is ready for A/B testing — trigger `eval.yml` manually.
- 3 skills in `skills/quarantine/` need human security sign-off before they can proceed.
- `catalog/mcps.json` and `catalog/plugins.json` are empty — Scout needs a focused run.

**Suggestion for next agent:**
Try the `agentic-planner.yml` workflow end-to-end with a simple test prompt. If it fails, check whether `ANTHROPIC_API_KEY` is set in repo secrets. Also consider triggering `eval.yml` on `recursive-research-synthesis-*` to get the first skill into `skills/evolved/`.

**Tags:** #harness #ruflo #devcontainer #state-docs #agentic-planner #codespaces
**Confidence in suggestions:** high
