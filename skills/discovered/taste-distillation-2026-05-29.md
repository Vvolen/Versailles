---
name: taste-distillation
description: >
  Extracts an expert's domain knowledge AND their tacit "taste" (the unwritten
  judgment that separates a master from a competent practitioner) into a portable
  expert profile that a sub-agent can load. Use when asked to clone a person's or
  source's expertise, build a domain expert persona, capture a decision-maker's
  style, or turn a corpus of an expert's work into a reusable agent. The core
  technique is contradiction mining: the places where an expert appears to
  contradict themselves are where their tacit rules are hiding.
metadata:
  author: Versailles (mined from owner's "AI Expertise" corpus)
  version: "1.0"
  origin: 'skills/quarantine/AI experts.txt (Taste Distillation breakthrough)'
---

# Taste Distillation

Most "expert" prompts capture only the **explicit** layer — facts and procedures the
expert could write down. They miss the layer that actually makes an expert valuable:
the **tacit** judgment, the "I just know this is wrong" instinct, the taste. This skill
extracts all four layers and emits a profile a forked sub-agent can load to *act* with
that taste — not just recite that knowledge.

> Mantra: **You're not capturing what the expert knows. You're capturing how the expert
> decides.**

## The four knowledge layers

| Layer | What it is | How to surface it |
|---|---|---|
| **Explicit** | Facts, definitions, procedures the expert can state | Direct extraction / summary |
| **Implicit** | Patterns they follow but don't articulate | Compare many examples; find the regularity |
| **Tacit** | Judgment/taste they can't fully explain ("it depends") | **Contradiction mining** (see below) |
| **Meta** | How they decide *which* knowledge applies when | Ask "when would you do the opposite?" |

## Instructions

### Phase 1 — Assemble the corpus
Gather concrete artifacts of the expert *deciding*, not just *describing*: past
decisions, reviews, critiques, accepted/rejected work, annotated examples, transcripts.
Decisions reveal taste; manifestos hide it.

### Phase 2 — Explicit extraction
Summarize the stated knowledge: definitions, rules, frameworks, vocabulary. Keep each
as an atomic, self-contained statement. This is the easy 80%.

### Phase 3 — Implicit pattern mining
Across many examples, find what the expert *consistently does* without saying so:
- "Always checks X before Y."
- "Rejects anything with property Z, even when unstated."
Write these as candidate rules with the examples that support each one.

### Phase 4 — Tacit extraction via CONTRADICTION MINING (the core move)
Find places where the expert appears to contradict themselves — they praised A here
but condemned a near-identical A there. **A contradiction is almost never a real
inconsistency; it is an unstated conditional rule firing.** For each contradiction:

```
CONTRADICTION:
  Case 1: expert APPROVED <thing> in context <C1>
  Case 2: expert REJECTED <near-identical thing> in context <C2>
  Hidden rule (hypothesis): the deciding factor is <difference between C1 and C2>
  → Tacit rule: "Prefer <thing> WHEN <condition>; avoid it WHEN <other condition>."
```

The recovered conditional rules ARE the taste. This phase is what makes the profile
behave like the expert instead of quoting them.

### Phase 5 — Meta extraction & profile assembly
Capture how the expert chooses which rules apply ("first I look at…, only then…").
Then assemble a portable **Expert Profile**:

```markdown
# Expert Profile: <domain> (<source>)
## Identity & stance
<who this expert is and their core orientation>
## Explicit knowledge (facts/procedures)
- ...
## Implicit patterns (always/never)
- ...
## Tacit rules (from contradiction mining) — conditional judgment
- Prefer X WHEN <cond>; avoid WHEN <cond>.
## Meta / decision order
1. First consider ... 2. Then ... 3. Only then ...
## Known limits / where this expert defers
- ...
## Source provenance
- corpus items used, dates, confidence per rule
```

### Phase 6 — Validate
Hold out a few of the expert's real decisions, give the profile only the inputs, and
check whether it predicts the expert's actual call. Track a hit rate; revise the tacit
rules that mispredict. Ship the profile with its validation score, not as gospel.

## Examples

### Example — recovering a tacit rule
> Corpus shows a code reviewer **approved** a 200-line function in a parser but
> **rejected** a 60-line function in an API handler.
> Surface contradiction: "short = good" is violated.
> Contradiction mining: the parser function was pure and well-tested; the API handler
> mixed validation, IO, and business logic.
> **Recovered tacit rule:** "Length is irrelevant; *mixed responsibilities* is the real
> trigger for rejection." That rule, not "keep functions short," is the taste.

### Example — output handoff to a forked expert
The assembled Expert Profile is small enough to load into an isolated sub-agent context
(progressive disclosure). The orchestrator forks an expert with *only* this profile +
the task, gets the decision, merges it, and discards the context — keeping the main
session clean (see `harness/power-ups/context-forking.md`).

## Guidelines

1. **Decisions over declarations.** Mine what the expert *did*, not what they *said* they
   do — taste lives in the choices.
2. **Treat every contradiction as a clue, never as noise.** The unwritten conditional is
   the highest-value artifact you will extract.
3. **Write tacit rules as conditionals** ("prefer X WHEN…"), never as absolutes.
4. **Always validate against held-out decisions** and ship the hit rate with the profile.
5. **Record provenance and per-rule confidence** — a tacit rule from two examples is a
   hypothesis, not a law (pairs naturally with the `soog-grounding-protocol` skill).
6. **Keep the profile small and loadable** so it fits a forked sub-agent's context.
7. **State the expert's limits.** Part of taste is knowing when to defer; capture that.
