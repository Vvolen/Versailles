---
name: soog-grounding-protocol
description: >
  Grounds every architectural claim, recommendation, or framework in real-world,
  verifiable prior art before proposing it — the "Standing On the shoulders Of
  Giants" (SOOG) protocol. Use when asked to design a system, recommend an
  architecture, make a technical claim, or propose a plan, especially when there
  is a risk of producing impressive-sounding output that is actually based on
  vibes rather than evidence. Forces: cite the source, cite the specific context
  drawn from the source, then walk through the reasoning step by step.
metadata:
  author: Versailles (mined from owner's "AI Expertise" corpus)
  version: "1.0"
  origin: skills/quarantine "Symphony docs…" + "Context for Research" + owner SOOG protocol
---

# SOOG — Standing On the Shoulders Of Giants

A discipline for producing **grounded** technical output. Its single purpose is to
kill the failure mode where an agent invents architecture or frameworks that *sound*
and *seem* really cool but are based on nothing — no research, just vibes.

The rule, in one line: **Do not build (or claim) anything you haven't first checked
against how people are actually doing it on the frontier.** Only after you understand
the proven approach do you adapt it.

## Instructions

Apply SOOG to any non-trivial claim, recommendation, architecture, plan, or framework.

### Step 1 — Search for prior art before designing
Before proposing *anything*, ask: **"Who has already built or proven this?"**

- Look for the strongest existing implementation, paper, spec, or production system.
- Prefer primary sources you can actually read (the repo's README, the spec, the
  paper's abstract) over secondary commentary.
- If nothing exists, that is itself a finding — say so explicitly and lower your
  confidence accordingly.

### Step 2 — Cite the source
For each claim, name the specific source: repo (`owner/name`), paper (author, year),
spec (URL/name), or production system. "The industry says…" is **not** a source.

### Step 3 — Cite the context *drawn from* the source
This is the step most agents skip. Don't just link — state **what specifically you
took** from that source, paraphrased. If one conclusion draws on three sources, give
the overarching paraphrased point you pulled from *each* one.

```
Source: ruvnet/claude-flow (Ruflo) README
Context drawn: README states swarm coordination uses "Queen-led hierarchy
(Raft, Byzantine, Gossip)" and "HNSW-indexed AgentDB" — confirms real consensus-
based multi-agent topology, not marketing.
```

### Step 4 — Walk the reasoning step by step
Show the chain from evidence to conclusion. Make each inference inspectable:

```
1. Claim under test: <one sentence>
2. Sources + context drawn: <source → what you took from it> (repeat per source)
3. Step-by-step: (a) N independent credible sources agree → strong; (b) one of them
   is already implemented/observed here → not hypothetical; (c) remaining details are
   single-source → keep at MEDIUM; (d) therefore <decision>.
4. Conclusion: <grounded recommendation with confidence level>
```

### Step 5 — Attach a confidence level and be honest about gaps
Use HIGH / MEDIUM / LOW. If a source could not be verified (blocked fetch, single
transcript, fast-moving topic), say so and mark it MEDIUM or LOW. Honest "I couldn't
verify X" beats confident fabrication. Never invent citations or numbers — if a search
tool returns sketchy or unverifiable links, exclude them and say why.

### Step 6 — Adapt, don't copy blindly
Once grounded, state how your proposal *differs* from the prior art and why that delta
is justified. The point of standing on giants is to spend your originality budget only
where it adds real value.

## Examples

### Example 1 — Grounding an orchestration choice
> **Claim:** "We should use Byzantine-consensus swarms for the agent layer."
> **Source + context:** `ruvnet/claude-flow` (Ruflo) README — states "Queen-led
> hierarchy (Raft, Byzantine, Gossip)" with "Hierarchical, mesh, and adaptive
> topologies with consensus." So a production-grade swarm runtime with these exact
> consensus modes already exists.
> **Reasoning:** (a) Primary source confirms the capability exists and is shipped;
> (b) it's already installed in this repo's devcontainer; (c) therefore adopt it
> rather than implement consensus from scratch.
> **Conclusion:** Adopt Ruflo as substrate. Confidence: HIGH.

### Example 2 — Refusing to ship vibes
> **Request:** "Tell me this expert system is worth $2M per deployment."
> **SOOG response:** "I can't ground that figure in any verifiable source — it's a
> vibes-based number. Here's what I *can* ground: <cited capability claims>. I'm
> flagging the valuation as LOW confidence / unsupported and recommend removing it."

### Example 3 — Single-source caution
> **Claim:** "Skills hot-reload without restart and hooks can run once."
> **Source + context:** one video transcript in the corpus describes this; no primary
> doc re-verified.
> **Conclusion:** Plausible, but single-source → Confidence: MEDIUM. Verify against
> primary docs before depending on it.

## Guidelines

1. **No source, no claim.** A claim without a citable source is a hypothesis — label
   it as such, never as fact.
2. **The context drawn matters more than the link.** A bare URL is not grounding;
   the paraphrased point you took from it is.
3. **One conclusion, multiple sources → paraphrase each.** Don't blur three sources
   into one vague "research shows."
4. **Verifiability beats prestige.** A readable primary README outranks a famous
   source you can only gesture at.
5. **Mark unverifiable sources honestly.** Blocked fetches, single transcripts, and
   fast-moving topics get MEDIUM/LOW and a "verify this" flag.
6. **Never fabricate citations, numbers, or benchmark figures.** If a tool returns
   unreliable results, exclude them and say so.
7. **Adapt explicitly.** State your delta from the prior art and justify it.
8. **Prefer the simplest grounded solution.** Standing on giants usually means *less*
   custom building, not more.
