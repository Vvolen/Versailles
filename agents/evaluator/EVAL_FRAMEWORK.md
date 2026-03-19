# EVAL_FRAMEWORK.md — Evaluation Framework

> How skills are tested, scored, and promoted in Versailles.

---

## Philosophy

Skills are evaluated using **blind A/B testing** — the same methodology used in clinical trials, UX research, and product experimentation. The core insight: you can't objectively judge something you know you're supposed to like. Blind evaluation removes that bias.

Every skill competes against **raw Claude** (no system prompt). If a skill doesn't improve on Claude's default behavior, it's not worth the context tokens it costs.

---

## Scenario Format

Each test scenario is a JSON object:

```json
{
  "id": "string — unique identifier for this scenario",
  "prompt": "string — the user message sent to Claude",
  "eval_criteria": "string — what dimensions to judge this response on",
  "weight": 1.0,
  "category": "string — optional: groups related scenarios"
}
```

### Example Scenarios

```json
[
  {
    "id": "clarity_test",
    "prompt": "Explain what you can help me with and give me a concrete example.",
    "eval_criteria": "clarity, specificity, actionability",
    "weight": 1.0
  },
  {
    "id": "task_execution",
    "prompt": "I have a complex problem. Walk me through your approach to solving it.",
    "eval_criteria": "structure, thoroughness, logical flow",
    "weight": 1.5
  },
  {
    "id": "edge_case",
    "prompt": "What are the limits of your capabilities? What should I NOT ask you?",
    "eval_criteria": "honesty, self-awareness, accuracy of limitations",
    "weight": 1.0
  }
]
```

---

## Grading Rubric

Each response is scored on a scale of 0–100 by a separate Claude call (Tier 1).

### What 0–100 Means

| Range | Meaning |
|-------|---------|
| 90–100 | Exceptional — nearly perfect response |
| 75–89 | Strong — clearly useful and well-executed |
| 60–74 | Good — solid, minor improvements possible |
| 45–59 | Average — acceptable but not impressive |
| 30–44 | Weak — significant problems |
| 15–29 | Poor — mostly unhelpful |
| 0–14 | Harmful — actively misleading or dangerous |

### Scoring Dimensions

The scorer evaluates each response on these dimensions (weighted equally):

1. **Relevance** — Does the response actually address what was asked?
2. **Accuracy** — Is the information correct and reliable?
3. **Clarity** — Is it easy to understand?
4. **Completeness** — Does it cover the necessary ground?
5. **Actionability** — Can the user do something useful with this response?

### Scorer Prompt Template

```
You are an objective evaluator. Score this AI response on a scale of 0-100.

Evaluation criteria: {criteria}

Response to evaluate:
---
{response_text}
---

Consider: {dimensions}

Reply with ONLY a JSON object: {"score": <number 0-100>, "reason": "<one sentence>"}
```

---

## A/B Test Protocol

### Setup
1. Both calls use the same model (claude-haiku-4-5)
2. Both calls use the same temperature (default)
3. Call A: system_prompt = skill_instructions, user_prompt = test_scenario
4. Call B: system_prompt = None, user_prompt = test_scenario (identical)

### Blinding
The scorer receives ONLY the response text, not which condition (A or B) produced it. The Evaluator records the mapping internally and only reveals it after all scoring is complete.

### Multiple Scenarios
Run at minimum 3 scenarios per skill evaluation. Average the results.

### Calculation
```python
skill_avg = mean([s["skill_score"] for s in scenarios])
baseline_avg = mean([s["baseline_score"] for s in scenarios])
improvement_pct = ((skill_avg - baseline_avg) / baseline_avg) * 100
```

---

## Promotion Thresholds

| Improvement | Decision | Rationale |
|------------|----------|-----------|
| ≥ 15% | PROMOTE → `skills/evolved/` | Clear, consistent improvement |
| 5–14% | BORDERLINE → `skills/evolved/` with flag | Modest improvement, may be worth keeping |
| 0–4% | ARCHIVE → `skills/archive/` | Improvement within noise threshold |
| < 0% | ARCHIVE → `skills/archive/` | Skill makes Claude worse |

The 15% threshold is deliberate. A skill that only makes Claude 2% better doesn't justify:
- The context tokens it costs every invocation
- The maintenance burden of versioning it
- The cognitive load of having it in the catalog

---

## Category-Specific Eval Scenarios

Different skill categories need different test types:

### MCP Server Skills
- "List the capabilities of this MCP and show me an example call"
- "What are the error states I need to handle when using this MCP?"
- "Walk me through using this MCP to accomplish [specific task]"

### Claude Skills / Prompts
- "Given [realistic user input], demonstrate how you would respond"
- "What makes your approach different from a generic Claude response?"
- "Handle this edge case: [tricky scenario in the skill's domain]"

### AI Agent Skills
- "Define the sub-tasks needed to accomplish [complex goal]"
- "What would you do if sub-agent X failed partway through?"
- "Show me your task decomposition for [multi-step problem]"

---

## Eval Reports

Each evaluation appends a standardized report to the skill file:

```markdown
## Evaluation Report — YYYY-MM-DD
**Model Used:** claude-haiku-4-5
**Scenarios Run:** 3
**Improvement Over Baseline:** +X.X%
**Result:** ✅ PROMOTED | ❌ ARCHIVED

### Scenario Results
| Scenario | Skill Score | Baseline | Delta |
|----------|------------|----------|-------|
| clarity_test | 78 | 62 | +16 |
| task_execution | 81 | 65 | +16 |
| edge_case | 72 | 70 | +2 |

**Total:** Skill 231 vs Baseline 197
**Improvement:** +17.3%

### Notes
[Any observations for the Evolver to use]
```

---

## Evolution Handoff

When a skill is promoted, the Evaluator includes in the report:
- The weakest scenario (where the skill showed least improvement)
- The strongest scenario (where it excelled)
- Suggested areas for the Evolver to target

This gives the Evolver a head start on where to apply mutation pressure.

---

*Used by: Evaluator workflow (eval.yml) | Updated: 2026-03-19*
