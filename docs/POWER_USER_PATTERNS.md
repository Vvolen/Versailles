# Power User Patterns — March 2026

**How the most effective GitHub + AI users are operating right now.**

This document captures patterns from the frontier of agentic development as of March 2026. These are the techniques that separate people building leverage from people just prompting.

---

## 1. Harness Engineering: The #1 Lever

The biggest performance differentiator in March 2026 is not which model you use — it's the **harness** you build around it.

**What top practitioners do:**
- Write dense `CLAUDE.md` or `AGENTS.md` files that encode all agent behavior upfront
- Use SOUL.md identity files to give agents consistent, stable personas
- Layer context with progressive disclosure (don't dump everything at once)
- Build role-specific tool access (agents only see the MCPs they need)

**The insight:** A mediocre model in a great harness beats a great model with no harness. Claude with your full operational context + tools + memory is categorically more capable than Claude with a blank system prompt.

**Versailles implements this via:** `CLAUDE.md`, `agents/*/SOUL.md`, `harness/mcp-gateway.json`, progressive disclosure rules

---

## 2. Issue-Driven Development

Top GitHub power users in 2026 treat Issues as the primary interface for AI delegation.

**The pattern:**
1. You write an Issue describing what you want (structured template)
2. A GitHub Actions workflow triggers on the label
3. An AI agent reads the issue, does the work, commits, opens a PR
4. You review and merge

**Why it works:**
- Issues are permanent records (no lost chat history)
- Issue templates force structured input (agents parse it reliably)
- The PR review step keeps humans in the loop for approval
- The git history is a full audit trail

**Versailles implements this via:** 3 issue templates + issue-triggered workflows

---

## 3. Multi-Agent Pipelines (Not Single Agents)

The most capable setups use **pipelines of specialized agents**, not one generalist agent.

**Anti-pattern:** "Hey Claude, discover tools, vet them for security, test them, and improve them all in one session"

**Power-user pattern:**
```
Scout (specialist) → Bouncer (specialist) → Evaluator (specialist) → Evolver (specialist)
```

Each agent:
- Has a single, clear responsibility
- Gets only the context it needs
- Commits its work to git before handing off
- Can be improved or replaced independently

**Tools for this:** `@claude-flow/cli`, GitHub Actions matrix jobs, GitHub Actions needs/dependency chains

**Versailles implements this via:** 4 specialized agents, chained workflows

---

## 4. Key Tools as of March 2026

### claude-flow (`@claude-flow/cli`)
The most widely used multi-agent orchestration framework. Provides:
- Agent spawning and lifecycle management
- HNSW memory for cross-session persistence
- Hierarchical topology (orchestrator → specialists)
- Built-in concurrency limits and timeouts
- MCP integration

**Install:** `npm install -g @claude-flow/cli@latest`

---

### Context7 (`@upstash/context7-mcp`)
MCP server for real-time library documentation. Instead of Claude hallucinating API signatures, Context7 resolves the actual current docs.

**Use when:** Working with any library or framework where accurate API knowledge matters.

**Install as MCP:** Add to `.mcp.json` (already configured in Versailles)

---

### MCPC (Appify's MCP CLI)
Progressive disclosure framework for MCP configurations. Implements the concept that agents should only see the tools relevant to their current task.

**Key insight it introduces:** MCP configurations should be role-based, not global. Different agents get different tool sets.

**Versailles implements this pattern via:** `harness/mcp-gateway.json`

---

### SkillFish
Tool for discovering, testing, and publishing Claude skills. The predecessor of what Versailles builds as a full pipeline.

**What Versailles does differently:** Versailles doesn't just discover skills — it security-vets them, A/B tests them, and evolves them through TDD.

---

### JCodeMunch
Tool for ingesting entire codebases into Claude's context intelligently. Handles chunking, summarization, and context prioritization.

**When to use:** When you need Claude to work with a large codebase, not just a single file.

---

### The "Everything Claude Code" Plugin (Anthropic Hackathon Winner)
Won the 2025 Anthropic hackathon. Key innovation: pre-loads the most relevant Claude Code capabilities contextually based on what you're working on.

**Core insight:** The right tool at the right time > all tools all the time.

**This is progressive disclosure applied to VS Code extensions.**

---

## 5. The SOUL.md Pattern (from re-marked/claude-corp)

The most stable, consistent agents have explicit identity files. A SOUL.md defines:
- Mission (one sentence)
- Values (3-5 principles)
- Decision framework (if X, do Y)
- Constraints (hard limits)
- Output format

**Why it works:** Without a SOUL.md, agents drift between sessions. They reinterpret their role based on the current prompt. With a SOUL.md, they have a stable identity that persists.

Every agent in Versailles has a SOUL.md. See `agents/*/SOUL.md`.

---

## 6. Git as Memory and Audit Trail

Top practitioners in 2026 use **git as their primary agent memory system**.

Instead of vector databases or external memory services:
- Every agent action = a commit
- Every discovery = a committed file
- Every decision = a commit message
- Every evolution = a version increment in the filename

**Why this beats vector databases for this use case:**
- No infrastructure to maintain
- Human-readable
- Full diff history
- Rollback with `git revert`
- Searchable with `git log --grep`
- Free with GitHub

---

## 7. 3-Tier Model Routing

Using the right model for the right task is a significant cost and performance lever.

| Task | Model | Why |
|------|-------|-----|
| JSON validation, pattern matching | claude-haiku | Fast, cheap, enough |
| Security analysis, scoring, documentation | claude-sonnet | Balanced reasoning |
| Architecture design, complex research, novel synthesis | claude-opus | Full reasoning power |

**The rule:** Start with the cheapest model that can do the job. Escalate only when needed.

Top practitioners route 70%+ of tasks to Haiku, 25% to Sonnet, 5% to Opus. This dramatically reduces costs while maintaining quality on tasks that matter.

**Versailles implements this via:** `CLAUDE.md` section 2 — 3-Tier Model Routing

---

## 8. Anti-Drift Checkpoints

One of the most underappreciated failure modes for AI agents is **context drift** — where an agent gradually loses track of what it was supposed to be doing.

**The fix:** Force checkpoints every N actions:

```
Every 10 actions, ask:
  1. Am I still working on the original task?
  2. Have I taken any actions I shouldn't have?
  3. What's my next action and does it align with the task?
```

This is implemented in CLAUDE.md section 3 (Anti-Drift Checkpoints) and is critical for long-running agents.

---

## 9. Security-First Skill Intake

**The number:** 37% of openly published AI skills contain malicious patterns.

Source: Security analysis of OpenHub-style skill packages, 2025-2026.

Top practitioners never use unvetted skills. Their intake process:
1. Source analysis (who made this? how old? how many stars?)
2. Static analysis (does it read environment variables? make unexpected network calls?)
3. Sandbox testing before production use
4. Regular re-vetting (tools change; a safe tool today might be compromised tomorrow)

**Versailles automates all of this via the Bouncer.**

---

## 10. The Architect Mindset

The most effective non-developer users of GitHub + AI in 2026 think of themselves as **architects**, not coders.

An architect:
- Defines the system structure (what does each agent do? how do they interact?)
- Sets the quality criteria (what makes a skill "good"?)
- Reviews outputs (PRs, research reports, eval results)
- Evolves the system design (update CLAUDE.md, tune thresholds)

An architect does NOT:
- Write the actual code (that's the agent's job)
- Debug syntax errors (that's the agent's job)
- Know every implementation detail (that's the agent's job)

**The leverage:** One architect with a well-designed agentic harness can outproduce a team of 10 traditional developers on the right problems.

---

*Last updated: March 2026 | See also: harness/HARNESS_ENGINEERING.md, DELEGATION_PLAYBOOK.md*
