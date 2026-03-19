# EVOLUTION_RULES.md — Skill Evolution Framework

> How skills are mutated, tested, and versioned in the TDD evolution loop.

---

## Philosophy

Evolution in biology works through random mutation + selection pressure. We do the same, but with intent: instead of random mutations, we apply targeted mutation strategies based on the skill's known weaknesses (from eval reports). Instead of natural selection, we use scoring functions.

The result is a **directed evolution** — faster and more efficient than random search, while still maintaining the rigor of empirical testing.

---

## Mutation Strategies

### Strategy 1: Refinement
**Goal:** Make existing instructions more precise and targeted.

**How:** Replace vague language with specific language. Replace "help the user" with "provide step-by-step instructions for." Replace "be thorough" with "include at least 3 examples."

**When to use:** When the skill scores inconsistently across scenarios. Vague instructions produce inconsistent outputs.

**Example:**
```
Before: "You are a helpful coding assistant."
After:  "You are an expert software engineer. For every coding question:
         1. Identify the core problem in one sentence
         2. Provide the solution with inline comments
         3. Identify 1-2 edge cases to watch for"
```

---

### Strategy 2: Compression
**Goal:** Achieve the same capability with 30%+ fewer tokens.

**How:** Remove redundant instructions (things Claude already does well by default). Eliminate filler phrases ("As an AI language model..."). Merge related instructions. Use structured formats instead of prose.

**When to use:** When the skill scores well but is unnecessarily verbose. Token cost matters.

**Example:**
```
Before: "You are an AI assistant that specializes in helping users with 
         their questions about data analysis. You should always be helpful 
         and try to provide useful information. When answering questions,
         please be thorough and provide examples when appropriate."
         
After:  "Data analysis specialist. Always provide: (1) direct answer, 
         (2) one concrete example, (3) relevant caveat if any."
```

---

### Strategy 3: Expansion
**Goal:** Add 2–3 adjacent capabilities without changing core behavior.

**How:** Identify common follow-up tasks that users would naturally want after using this skill. Add handling for these cases.

**When to use:** When the skill excels at its core task but users would benefit from adjacent capabilities.

**Example:**
```
Before: "You are a SQL query writer. Generate optimized SQL for the user's request."

After:  "You are a SQL query writer. Generate optimized SQL for the user's request.
         Additionally:
         - If the query might be slow, explain why and suggest an index
         - If the user seems new to SQL, briefly explain key concepts used
         - If asked about a database type you're uncertain about, say so explicitly"
```

---

### Strategy 4: Specialization
**Goal:** Narrow the skill's focus to one specific use case where it excels.

**When to use:** When eval shows the skill is mediocre across many scenarios but excellent in one. Better to be great at one thing than average at many.

---

### Strategy 5: Restructuring
**Goal:** Change the fundamental format or approach of the skill.

**When to use:** When 3+ other strategies have been tried with minimal improvement. Sometimes the whole approach needs rethinking.

---

### Strategy 6: Persona Shift
**Goal:** Change the persona framing to affect response tone and depth.

**When to use:** When content is fine but responses feel generic. Persona framing can dramatically change output quality.

**Example:**
```
Before: "You are a helpful assistant for writing."
After:  "You are a senior editor at The New Yorker with 20 years of 
         experience. You have extremely high standards and give direct, 
         specific feedback without softening criticism."
```

---

## Generation Tracking

Each evolution cycle increments the version number and appends a record:

### Filename Convention
```
skills/evolved/<name>-v1-evolved.md        # Generation 1 (from Evaluator)
skills/evolved/<name>-v2-evolved.md        # Generation 2 (first mutation)
skills/evolved/<name>-v3-evolved.md        # Generation 3 (second mutation)
```

### Evolution Record Format
```markdown
## Evolution Record — Generation <N>
**Date:** YYYY-MM-DD
**Strategy Applied:** <strategy name>
**Previous Version:** <name>-v<N-1>-evolved.md
**Previous Score:** <N.N>
**New Score:** <N.N>
**Improvement:** +<N.N>%
**Notes:** <what changed and why>
```

---

## Fitness Function

The fitness of a skill is measured by its **average A/B improvement over baseline** across the standard test scenarios.

```
fitness(skill) = mean([score(skill, scenario_i) / score(baseline, scenario_i) for i in scenarios])
```

A fitness of 1.0 = same as raw Claude
A fitness of 1.15 = 15% better than raw Claude (minimum for promotion)
A fitness of 1.35 = 35% better (exceptional)

---

## Stagnation Detection

A skill is **stagnant** if:
```
last_5_improvements = [gen_n - gen_n-1 for n in range(current_gen-5, current_gen)]
all(improvement < 2.0 for improvement in last_5_improvements)
```

When stagnation is detected:
1. Try the **Restructuring** strategy one final time
2. If still < 2% improvement: retire to `skills/archive/`
3. Log the retirement reason in CHANGELOG

---

## Mutation Process

```
1. Load skill file
2. Extract current generation number from filename
3. Generate 3 targeted test prompts (based on skill purpose)
4. Score current version against test prompts → current_score
5. For each mutation strategy [refinement, compression, expansion]:
   a. Apply mutation (Tier 2 call — Sonnet)
   b. Score mutant against test prompts (Tier 1 call — Haiku)
   c. Record: (strategy, mutant_content, score)
6. Select best mutation (highest score)
7. If best_score > current_score + 5%:
   a. Write new version file (v<N+1>)
   b. Append Evolution Record
   c. Archive old version
   d. Update CHANGELOG
8. If best_score <= current_score + 5%:
   a. Log "no improvement" in CHANGELOG
   b. Increment stagnation counter
   c. Check stagnation threshold
```

---

## Budget Management

To stay within reasonable API costs:
- Max 3 skills evolved per daily cycle
- Max 3 mutation strategies tried per skill
- Max 3 test scenarios per scoring call
- Use Haiku for scoring (not Sonnet or Opus)
- Use Sonnet for mutation generation (not Opus, unless restructuring)

Estimated cost per skill per cycle: ~$0.05–0.15 depending on skill length.

---

## Examples of Successful Evolutions

### Example: Code Review Skill, v1 → v2
**Strategy:** Refinement
**v1 score:** 72.3
**v2 score:** 84.1
**Improvement:** +16.3%

**What changed:** Added specific format requirements (numbered items, severity labels, code examples). Removed vague "be thorough" instruction. Added explicit instruction to check for security issues.

### Example: Research Skill, v2 → v3
**Strategy:** Compression  
**v2 score:** 81.0
**v3 score:** 83.5
**Improvement:** +3.1%

**Note:** Below 5% threshold — archived after one more generation attempt with expansion strategy also failed.

---

*Used by: Evolver workflow (evolve.yml) | Updated: 2026-03-19*
