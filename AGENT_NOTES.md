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
Run the Scout workflow manually via workflow_dispatch to populate the skills/discovered/
directory with real discoveries from GitHub. The Scout script is functional Python that
searches the GitHub API and scores repos — it just needs to be triggered. After that,
trigger the Bouncer to vet them. This will validate the entire pipeline end-to-end.

**Open question:**
The devcontainer installs `@claude-flow/cli@latest` at startup, but the workflows themselves
don't use claude-flow — they're standalone Python scripts embedded in YAML. Should the
workflows be refactored to use claude-flow for multi-agent orchestration, or is the current
"embedded Python in YAML" approach sufficient? The tradeoff is simplicity vs. scalability.

**Tags:** #architecture #skills #pipeline #memory #research
**Confidence in suggestions:** high

---

<!-- ADD YOUR ENTRY HERE ↓ -->
