# Delegation Playbook — Operating as an Architect

**Your personal operating manual for running an AI-powered organization from GitHub.**

---

## The Core Mindset Shift

Most people learn to code because they want to build things. You don't need to.

The mindset shift is this:

> **You are not the person who builds. You are the person who decides what to build, sets the standards, reviews the results, and evolves the system.**

In architecture firms, the lead architect never swings a hammer. They design the building, review structural plans, approve material choices, and ensure the vision is executed correctly. The builders do the building.

That's your role here. GitHub + Copilot + Versailles are your builders.

---

## The Delegation Loop

Everything in Versailles follows this loop:

```
1. DECIDE    → What do you want? Articulate it clearly.
2. DELEGATE  → Create an Issue or trigger a workflow.
3. REVIEW    → Check the PR or results.
4. APPROVE   → Merge the PR, or provide feedback.
5. EVOLVE    → Update your criteria based on what you learned.
```

Repeat. Over time, the system improves and the cost of each loop decreases.

---

## Issue-Driven Development: The Daily Workflow

This is how you operate Versailles day-to-day:

### Morning (5 minutes)
1. Check **Actions** tab — did anything run overnight?
2. Check **Pull Requests** — any research reports or skill evolutions ready to review?
3. Check `catalog/CHANGELOG.md` — what did the agents discover?

### When You Want Something Done
1. Think: "What do I want to know or have?"
2. Open an Issue with the appropriate template
3. Done. The agent picks it up.

### Weekly Review (15 minutes)
1. Look at `skills/evolved/` — what production skills exist now?
2. Look at `research/findings/` — any reports worth reading?
3. Look at `skills/quarantine/` — anything the Bouncer blocked that you want to manually review?
4. Update your priorities by triggering the relevant workflows

---

## How to Write Good Issues (For Agents)

Agents read your Issues. The better you write them, the better the output.

### Good Issue Characteristics

**Be specific about the goal:**
```
❌ "Research Solana"
✅ "Research the top 5 Solana MCP servers that would allow an AI agent 
    to: (1) read wallet balances, (2) monitor transactions in real-time, 
    (3) execute swaps on DEXs. I want to know how to actually set these 
    up and what the tradeoffs are."
```

**Provide context:**
```
❌ "Evolve the code review skill"
✅ "Evolve the code review skill. Current problem: it gives generic 
    feedback that doesn't catch security issues. Desired behavior: 
    it should specifically check for SQL injection, hardcoded credentials, 
    and missing input validation."
```

**State your criteria:**
```
❌ "Find good AI agents"
✅ "Find AI agents that work with Solana. Must: have >100 stars, be 
    updated in last 6 months, not require a centralized server, work 
    with the Anthropic API."
```

---

## Setting Up New Repositories Using the Versailles Template

When you want to start a new project with the same agentic infrastructure:

### Quick Method
1. Go to github.com/Vvolen/Versailles
2. Click **Use this template** (if enabled) or fork the repo
3. Update `CLAUDE.md` to reflect the new project's purpose
4. Update the agent SOUL.md files for the new domain
5. Adjust workflow thresholds in the YAML files as needed

### Key Files to Customize for a New Project
| File | What to Change |
|------|---------------|
| `CLAUDE.md` | Section 1 (Repository Purpose), security rules for your domain |
| `agents/scout/CRITERIA.md` | Scoring rubric for your specific tool categories |
| `agents/bouncer/SECURITY_CHECKS.md` | Any domain-specific security concerns |
| `README.md` | Project description and architecture |
| `.github/ISSUE_TEMPLATE/` | Adjust fields for your domain |

---

## Scaling: One Person, Many Agents

The power of this setup is that it scales non-linearly.

**What stays constant (your time):**
- Deciding what to research or build
- Reviewing outputs
- Evolving the system

**What scales with agents:**
- Number of tools discovered per week
- Number of skills tested and improved
- Depth of research on any topic
- Speed of iteration

One well-designed Versailles instance can run dozens of parallel agent tasks. You review the results. You become the bottleneck, not the builder.

**Practical limits:**
- You can meaningfully review ~5-10 PRs per day
- You can make ~10-20 strategic decisions per day
- You can evolve the system in ~30 minutes per week

Design your agent workload around your review capacity, not the agents' capacity.

---

## When to Intervene vs. Let It Run

**Let it run:**
- Scout discovering tools every 6 hours
- Bouncer vetting discoveries
- Evolver improving skills nightly
- Self-Heal validating on every push

**Intervene when:**
- Bouncer quarantines a tool you specifically wanted
- Evaluator archives a skill you think is valuable
- Research report misses the point of your question
- The system is discovering things that don't match your priorities

**How to intervene:**
- Manual file moves (GitHub web UI → drag or upload files)
- Workflow input overrides (Run workflow → fill in custom parameters)
- Issue comments with refinement requests
- Update CRITERIA.md or SOUL.md files to adjust agent behavior long-term

---

## The Feedback Loop That Improves Everything

The most powerful thing you can do is close the loop between what agents discover and what you care about.

**After a Scout run:**
- Check `skills/discovered/` — do these tools match what you need?
- If not: Update `agents/scout/CRITERIA.md` with better criteria
- The next Scout run will find better tools

**After an Evaluator run:**
- Check `skills/evolved/` — are these skills actually useful to you?
- If not: Update `agents/evaluator/EVAL_FRAMEWORK.md` with better test scenarios
- The next Evaluator run will select better skills

**After a Research report:**
- Was the research deep enough? Did it answer your questions?
- If not: Create a follow-up research issue with more specific questions
- Over time, your research methodology improves

This is the self-improving loop at the human level. You improve the system. The system improves its outputs. Better outputs inform better decisions.

---

## Connecting to Your Other Repositories

**Versailles → Foundation-layer:**
The evolved skills in Versailles can be used as processing modules in the Foundation-layer pipeline. When a skill matures, consider adding it to the Foundation-layer as a specialized node in the knowledge ingestion pipeline.

**Versailles → MUNCH:**
New MCP servers discovered by the Scout can be added to the MUNCH-CONTEXT-PROTOCOL-MCP- configuration. This expands the tool layer available to the MUNCH harness.

**General pattern:**
```
Versailles discovers and vets → feeds best tools → other repositories
```

Versailles is the intake and quality filter. Other repositories consume its outputs.

---

## Quick Reference: What to Do When...

| You Want To | Action |
|------------|--------|
| Discover new tools | Actions → Scout → Run workflow |
| Research a topic deeply | New Issue → Research Request template |
| Improve a specific skill | New Issue → Skill Evolution template |
| Report a tool you found | New Issue → Skill Discovery template |
| Review security-blocked tools | Check `skills/quarantine/` folder |
| See what agents found this week | Check `catalog/CHANGELOG.md` |
| Give an agent better instructions | Edit the relevant SOUL.md or CRITERIA.md |
| Add a new agent capability | Add to CLAUDE.md → create new workflow |
| Check system health | Actions → Self-Heal → Run workflow |

---

*This is a living document. Update it as your operating patterns evolve.*

*See also: GETTING_STARTED.md, POWER_USER_PATTERNS.md, HARNESS_ENGINEERING.md*
