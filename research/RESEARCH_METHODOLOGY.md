# RESEARCH_METHODOLOGY.md — How Recursive Self-Improving Research Works

## Overview

Versailles uses **iterative deepening research** — a technique borrowed from game tree search algorithms. Instead of doing one big research pass, it makes multiple progressively deeper passes, each one building on and refining the previous.

This mirrors how expert human researchers work: first a broad survey, then diving into the most interesting threads, then synthesizing, then checking edge cases.

---

## The Research Loop Algorithm

```
function recursive_research(topic, depth):
  
  iteration_1 = initial_survey(topic)
    → What is this? Who are the key players? What exists?
  
  if depth == 1: return compile(iteration_1)
  
  gaps = identify_gaps(iteration_1)
  iteration_2 = deep_dive(topic, gaps, context=iteration_1)
    → Technical details, comparisons, tradeoffs
  
  if depth == 2: return compile(iteration_1, iteration_2)
  
  iteration_3 = synthesis(topic, context=[iteration_1, iteration_2])
    → Patterns, recommendations, open questions
  
  [... continues to depth N ...]
  
  return compile_report(all_iterations, format)
```

---

## Depth Levels

| Depth | Iterations | Time | Use When |
|-------|-----------|------|----------|
| Surface (1) | 1 | ~2 min | Quick orientation on a new topic |
| Standard (3) | 3 | ~6 min | Most research needs |
| Deep (5) | 5 | ~12 min | Important decision-making |
| Expert (7+) | 7+ | ~20 min | Architecture decisions, security research |

---

## Iteration Types

### Iteration 1: Initial Survey
**Goal:** Broad orientation

**Questions answered:**
- What is this topic about?
- Who are the key players (people, orgs, tools, repos)?
- What is the current state of the art?
- What are the main categories or approaches?

**Output:** 400–800 words covering the landscape

---

### Iteration 2: Technical Deep Dive
**Goal:** Understand how things actually work

**Questions answered:**
- How does X technically work?
- What are the tradeoffs between approach A and approach B?
- What are the limitations and edge cases?
- What does the code/architecture look like?

**Output:** 600–1,200 words with technical specifics

---

### Iteration 3: Synthesis and Recommendations
**Goal:** Distill knowledge into actionable guidance

**Questions answered:**
- Given everything found, what should I actually do?
- What are the top 3–5 recommendations?
- What are the risks and how do I mitigate them?
- What are the open questions I still don't know?

**Output:** 400–800 words of concrete guidance

---

### Iterations 4–7: Expert Refinement
**Goal:** Cover gaps, edge cases, and nuance

Each iteration addresses the most significant gap or uncertainty from previous iterations. The researcher explicitly identifies what's still unknown and focuses on that.

---

## Output Formats

### Full Report
Structured document with: Executive Summary, Background, Detailed Findings, Comparisons, Recommendations, Open Questions

### Executive Summary
1–2 pages: Key findings + 3 action items. Fastest to read.

### Comparison Table
Side-by-side comparison of options. Best when choosing between alternatives.

### Action Plan
Findings + ordered next steps. Best when the goal is "what do I do next?"

### Annotated List
Curated list with 1–2 sentence explanations. Best for tool/resource catalogs.

---

## File Structure

```
research/
  topics/
    <topic-slug>.md          # Topic brief: what we know, what we want to find
  findings/
    <topic-slug>-YYYY-MM-DD.md   # Completed research report
```

### Topic File Format
```markdown
# <Topic>

**Status:** researching | completed | superseded
**Created:** YYYY-MM-DD
**Latest Findings:** [link to findings file]

## What We Want to Know
[Specific questions to answer]

## What We Already Know
[Prior context]
```

### Findings File Format
```markdown
# Research: <Topic>

**Completed:** YYYY-MM-DD
**Depth:** N iterations
**Format:** <format type>

---

[Executive Summary]

---

[Main Report Content]

---

## Research Iterations (Raw)
[Collapsible: all raw iterations]
```

---

## Quality Standards

Research findings in Versailles meet these standards:

1. **Specificity** — Name actual tools, repos, people, companies. No vague claims.
2. **Currency** — Note the knowledge cutoff date. Flag things that may have changed.
3. **Source Awareness** — Distinguish between "I know this" and "I inferred this" and "I'm uncertain about this."
4. **Actionability** — Every report ends with at least 3 concrete next steps.
5. **Honesty About Gaps** — Explicitly state what isn't known. Don't paper over uncertainty.

---

## Integration with the Skill Pipeline

Research findings often identify new tools → those tools feed into the Scout's discovery list.

```
Research finds: "tool-X is the best MCP for Y"
         ↓
Scout adds tool-X to skills/discovered/
         ↓
Bouncer vets tool-X
         ↓
Evaluator tests tool-X
         ↓
tool-X enters skills/evolved/ as a production skill
```

The Researcher and Scout are complementary: Scout casts a broad net, Researcher goes deep on specific topics.

---

*Updated: 2026-03-19 | Used by: research.yml workflow*
