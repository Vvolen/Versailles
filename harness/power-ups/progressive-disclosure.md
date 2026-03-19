# Progressive Disclosure — Power-Up Guide

## What Is Progressive Disclosure?

Progressive disclosure is a design principle: **don't overwhelm with all options at once — show what's needed, when it's needed.**

Applied to AI agent harness engineering (as pioneered by MCPC — the MUNCH-CONTEXT-PROTOCOL system), it means:

> **Agents only see the tools and context they need for their current task stage.**

---

## Why It Matters for AI Agents

Context windows are finite and expensive. Attention is diluted by irrelevant information. Agents that receive everything at once perform worse than agents that receive information progressively.

**Research finding:** Agents given a focused 2K-token context often outperform agents given a 20K-token context dump, because the relevant signal is clearer.

---

## The 4 Context Levels

### Level 0 — Always Present
The minimum context every agent receives at startup. Never omit these.

```
- CLAUDE.md (constitution)
- agents/<role>/SOUL.md (identity)  
- Task description (what to do right now)
```

Cost: ~1,000–2,000 tokens

---

### Level 1 — Domain Knowledge
Loaded when the agent's task requires domain-specific methodology.

```
- agents/bouncer/SECURITY_CHECKS.md    (for security tasks)
- agents/scout/CRITERIA.md             (for scoring tasks)
- agents/evaluator/EVAL_FRAMEWORK.md   (for evaluation tasks)
- agents/evolver/EVOLUTION_RULES.md    (for mutation tasks)
- research/RESEARCH_METHODOLOGY.md     (for research tasks)
```

**Load trigger:** Task type determines which doc to load.

Cost: +1,000–3,000 tokens

---

### Level 2 — Artifact Context
Loaded when processing a specific file or data object.

```
- The specific skill file being evaluated/evolved/vetted
- The specific research topic file
- Relevant catalog entries
- Prior eval reports for the skill
```

**Load trigger:** The identity of the artifact being processed.

Cost: +500–5,000 tokens (depending on artifact size)

---

### Level 3 — Deep Investigation
Rarely loaded. Only for complex forensics or architecture decisions.

```
- Full git history of a skill
- Complete catalog data
- All evolution records for a skill family
- Raw GitHub API responses
- Multiple research findings on related topics
```

**Load trigger:** Explicit escalation. Must justify in task log.

Cost: +5,000–50,000 tokens

---

## MCPC Pattern

The MCPC (MUNCH-CONTEXT-PROTOCOL-MCP) project formalized progressive disclosure for Claude agents. Key patterns:

### Pattern 1: Contextual Tool Activation

Don't give every agent access to every MCP. Activate MCPs based on role:

```json
// harness/mcp-gateway.json
{
  "scout": ["github", "filesystem"],
  "bouncer": ["filesystem", "sequential-thinking"],
  "evaluator": ["filesystem"],
  "researcher": ["github", "filesystem", "context7"]
}
```

This is progressive disclosure at the **tool layer** — not context, but capability.

---

### Pattern 2: Staged Context Loading

```python
def run_agent(task, role):
    # Level 0: Always
    context = [
        load("CLAUDE.md"),
        load(f"agents/{role}/SOUL.md"),
        task.description
    ]
    
    # Level 1: Based on task type
    if task.type == "security_review":
        context.append(load("agents/bouncer/SECURITY_CHECKS.md"))
    elif task.type == "evaluation":
        context.append(load("agents/evaluator/EVAL_FRAMEWORK.md"))
    
    # Level 2: Based on specific artifact
    if task.target_file:
        context.append(load(task.target_file))
    
    # Run with focused context
    return claude.complete(system="\n\n".join(context), prompt=task.prompt)
```

---

### Pattern 3: Ask Before Loading

For uncertain cases, let the agent ask for context rather than pre-loading it:

```
System: You have access to CRITERIA.md if you need it. 
        Ask for it by saying: "LOAD: agents/scout/CRITERIA.md"

User: Score this tool on the 5-dimension rubric.

Agent: LOAD: agents/scout/CRITERIA.md
[Context loader provides the file]
Agent: [Scores using the rubric]
```

This is especially useful when you're not sure which Level 1 docs the agent will need.

---

## Common Mistakes

❌ **Dumping the whole repo into system prompt** — 50K tokens of context, 2K of which are actually relevant

❌ **Loading Level 3 context for Tier 1 tasks** — Full git history for "is this JSON valid?"

❌ **Not loading Level 1 when needed** — Agent makes up its own methodology instead of following CRITERIA.md

❌ **Static context that never changes** — The context should reflect the current task, not be hardcoded

---

## Measuring Effectiveness

You'll know progressive disclosure is working when:
- Agent outputs are more focused and less generic
- Token costs per task decrease
- Agents reference specific documents they were given (not made-up rules)
- Fewer "hallucinated" methodology claims

---

*Used by: All Versailles agents | Pioneered by: MCPC / RuFlo V3 architecture*
