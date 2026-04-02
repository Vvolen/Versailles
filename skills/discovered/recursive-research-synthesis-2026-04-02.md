---
name: recursive-research-synthesis
description: >
  Performs deep, multi-iteration research with progressive synthesis, source
  credibility scoring, and structured confidence-rated findings. Use when
  conducting research that requires exploring multiple sources, synthesizing
  findings across documents, evaluating conflicting information, or producing
  comprehensive research reports with confidence levels.
---

# Recursive Research Synthesis

A structured methodology for conducting deep research that goes beyond surface-level
answers. This skill teaches agents to research in iterative layers, cross-reference
findings, detect diminishing returns, and produce synthesis reports where every
claim carries an explicit confidence level.

## Instructions

### The 3-Layer Research Model

Research is not a single pass. Treat it as three distinct phases, each building
on the previous:

```
┌─────────────────────────────────────────┐
│  LAYER 1: SURFACE SCAN                  │
│  Goal: Map the landscape                │
│  Time: ~20% of research budget          │
│  Output: Key terms, major sources,      │
│          initial taxonomy                │
├─────────────────────────────────────────┤
│  LAYER 2: DEEP INVESTIGATION            │
│  Goal: Extract detailed evidence        │
│  Time: ~50% of research budget          │
│  Output: Findings with citations,       │
│          contradictions identified       │
├─────────────────────────────────────────┤
│  LAYER 3: SYNTHESIS & VALIDATION        │
│  Goal: Reconcile, validate, conclude    │
│  Time: ~30% of research budget          │
│  Output: Final report with confidence   │
│          levels and recommendations      │
└─────────────────────────────────────────┘
```

---

### Layer 1: Surface Scan

**Objective:** Understand the shape of the topic before diving deep. Build a mental
map of key players, terminology, and sub-domains.

**Steps:**

1. **Define the research question precisely.**
   Bad: "What are the best databases?"
   Good: "What are the trade-offs between PostgreSQL and DynamoDB for a
   write-heavy event-sourcing workload processing 50K events/second?"

2. **Identify 3–5 seed sources.** Start with:
   - Official documentation or specifications
   - Highly-cited survey papers or review articles
   - Recognized expert blogs or conference talks (check credentials)
   - GitHub repos with >1000 stars (for technical topics)

3. **Extract the taxonomy.** From your seed sources, build a concept map:
   ```
   Main Topic
   ├── Sub-topic A
   │   ├── Key concept A1
   │   └── Key concept A2
   ├── Sub-topic B
   │   ├── Key concept B1
   │   └── Key concept B2 (controversial — sources disagree)
   └── Sub-topic C (unexplored — flag for Layer 2)
   ```

4. **Collect key terminology.** New domains have specialized vocabulary. List the
   10–20 most important terms with working definitions. These become your search
   queries for Layer 2.

5. **Identify knowledge gaps.** What did the seed sources NOT cover? What questions
   do they raise? These gaps drive Layer 2.

**Surface Scan Checkpoint:**
```
[ ] Research question is specific and bounded
[ ] 3–5 seed sources identified and skimmed
[ ] Taxonomy of sub-topics constructed
[ ] Key terminology collected
[ ] Knowledge gaps identified for Layer 2
[ ] No more than 20% of time budget consumed
```

---

### Layer 2: Deep Investigation

**Objective:** Gather detailed evidence for each branch of your taxonomy. This is
where you spend most of your research effort.

**Steps:**

1. **Prioritize branches.** Not all sub-topics deserve equal depth. Rank by:
   - Relevance to the original research question (1–5)
   - Current knowledge gap (1–5)
   - Likely impact on conclusions (1–5)
   - Investigate highest-scoring branches first.

2. **For each priority branch, apply the Evidence Gathering Protocol:**

   a. **Find 3+ independent sources** that address this sub-topic. "Independent"
      means: different authors, different organizations, ideally different
      publication contexts (academic vs. industry vs. practitioner).

   b. **Extract claims as atomic statements.** Don't summarize — decompose:
      ```
      Source says: "Redis is faster than PostgreSQL for caching but less durable."

      Atomic claims:
      - Claim: Redis has lower read latency than PostgreSQL for cache workloads
        Source: [reference]
        Evidence type: Benchmark (empirical)
      - Claim: Redis provides weaker durability guarantees than PostgreSQL
        Source: [reference]
        Evidence type: Architecture analysis (theoretical)
      ```

   c. **Tag each claim with evidence type:**
      - **Empirical** — Based on measurements, benchmarks, experiments, data
      - **Theoretical** — Based on architecture, design analysis, proofs
      - **Anecdotal** — Based on personal experience, case studies (single)
      - **Consensus** — Widely agreed upon by multiple authoritative sources
      - **Contested** — Sources actively disagree on this point

   d. **Cross-reference claims.** For each claim, ask:
      - Does any other source confirm this? → strengthens confidence
      - Does any source contradict this? → flag for synthesis
      - Is this claim cited by others? → check the citation chain

3. **Track contradictions explicitly.** Create a contradictions log:
   ```
   CONTRADICTION #1:
   Claim A: "Microservices reduce deployment risk" (Source: Martin Fowler, 2015)
   Claim B: "Microservices increase operational risk" (Source: DHH, 2016)
   Possible resolution: Different definitions of "risk" — deployment vs. operational
   Status: NEEDS SYNTHESIS
   ```

4. **Apply the Progressive Disclosure Pattern for scope expansion:**
   - Start with your specific question
   - If findings raise adjacent questions that are critical to the conclusion,
     expand scope — but only by one hop
   - Never expand scope more than twice without re-evaluating the research question
   - Document each expansion:
     ```
     SCOPE EXPANSION #1:
     Original scope: PostgreSQL vs. DynamoDB for event sourcing
     Expansion: How do connection pooling strategies affect PostgreSQL write throughput?
     Justification: Source X suggests PgBouncer is essential for high-write workloads;
     this may invalidate raw PostgreSQL benchmarks
     ```

5. **Detect and resist confirmation bias.** After finding 3+ sources supporting
   a conclusion, deliberately seek disconfirming evidence:
   - Search for "[topic] criticism" or "[topic] problems" or "[topic] vs"
   - Look for failed case studies, not just success stories
   - Check if supportive sources share a common incentive (e.g., vendor content)

**Deep Investigation Checkpoint:**
```
[ ] Priority branches ranked and top 3–5 investigated
[ ] 3+ independent sources per major claim
[ ] All claims tagged with evidence type
[ ] Contradictions logged with potential resolutions
[ ] Scope expansions documented and justified (max 2)
[ ] Confirmation bias check performed
[ ] No more than 70% of total time budget consumed
```

---

### Layer 3: Synthesis and Validation

**Objective:** Reconcile findings into a coherent report with confidence levels.
This is where raw research becomes actionable intelligence.

**Steps:**

1. **Resolve contradictions.** For each logged contradiction:
   - Can the contradiction be explained by differing contexts? (Most common)
   - Is one source more credible than the other? (Use credibility scoring below)
   - Is the contradiction a genuine open question? (Document as such)

2. **Assign confidence levels to each finding using this rubric:**

   | Confidence | Criteria |
   |------------|----------|
   | **HIGH** (90–100%) | 3+ independent, credible sources agree. Empirical evidence available. No significant contradictions. |
   | **MEDIUM** (60–89%) | 2+ sources agree. Some empirical evidence. Minor contradictions exist but are resolved. |
   | **LOW** (30–59%) | Single source or multiple sources with weak evidence. Unresolved contradictions. Primarily anecdotal. |
   | **SPECULATIVE** (<30%) | No direct evidence. Inferred from adjacent findings. Clearly flagged as hypothesis. |

3. **Build the synthesis narrative.** Don't just list findings — connect them:
   - What is the overall picture that emerges?
   - What are the key trade-offs?
   - What are the actionable recommendations?
   - What remains unknown?

4. **Validate completeness.** Check your synthesis against the original research
   question:
   - Does the report actually answer the question asked?
   - Are there critical sub-questions left unanswered?
   - Would a reader need to do additional research to make a decision?

---

### Source Credibility Scoring

Rate every source on 4 dimensions (1–5 each, max 20):

| Dimension | 1 (Low) | 3 (Medium) | 5 (High) |
|-----------|---------|------------|----------|
| **Authority** | Anonymous blog, no credentials | Industry practitioner, some credentials | Peer-reviewed, recognized expert |
| **Recency** | >5 years old, likely outdated | 2–5 years old | <2 years old, current |
| **Evidence** | Opinions only, no data | Some data or case studies | Rigorous methodology, reproducible |
| **Independence** | Vendor content, clear bias | Practitioner with potential bias | Independent, no financial incentive |

**Scoring thresholds:**
- 16–20: Highly credible — use as primary evidence
- 11–15: Credible — use as supporting evidence
- 6–10: Marginally credible — use only for context or to identify patterns
- 1–5: Low credibility — do not cite as evidence, note for completeness only

---

### Diminishing Returns Detection

Stop research on a sub-topic when any of these conditions are met:

1. **Redundancy threshold:** 3 consecutive sources add no new claims or evidence.
2. **Confidence saturation:** All major claims already at HIGH confidence.
3. **Tangent detection:** New sources are increasingly tangential to the research
   question — you are drifting.
4. **Time budget exhaustion:** You have consumed 80% of your time budget.
5. **Circular references:** Sources cite each other — no independent evidence chain
   exists beyond what you already have.

When you detect diminishing returns, emit:
```
DIMINISHING RETURNS DETECTED on sub-topic: [name]
Reason: [which condition triggered]
Current confidence: [level]
Decision: [STOP / one more source / escalate to human]
```

---

### Avoiding Common Research Pitfalls

1. **Availability bias:** Don't over-weight sources just because they appeared
   first in search results. Deliberately seek diverse source types.

2. **Authority bias:** A prestigious source can still be wrong. Check claims from
   authority figures the same way you check claims from anyone else.

3. **Recency bias:** Newer isn't always more accurate. Foundational papers from
   10+ years ago may be more reliable than recent blog posts.

4. **Survivorship bias:** Success stories are published; failures are not. Actively
   seek post-mortems, failure analyses, and negative results.

5. **Anchoring:** Don't let the first finding anchor your entire research. If your
   first source says "X is the best approach," don't frame all subsequent research
   as "confirming X" or "disproving X."

6. **Scope creep:** Research can expand infinitely. Use the 2-expansion limit
   and diminishing returns detection to stay bounded.

## Output Format

### Research Report Template

```markdown
# Research Report: [Title]

**Research Question:** [Precise question being investigated]
**Date:** [Date]
**Researcher:** [Agent ID / Skill name]
**Time Budget:** [allocated] | **Time Used:** [actual]
**Scope Expansions:** [0/1/2 — list if any]

## Executive Summary
[3–5 sentences answering the research question directly. Include overall
confidence level.]

## Key Findings

### Finding 1: [Title]
**Confidence:** HIGH / MEDIUM / LOW / SPECULATIVE
**Evidence Type:** Empirical / Theoretical / Consensus / Contested
**Sources:** [list with credibility scores]

[Detailed description of finding]

### Finding 2: [Title]
...

## Contradictions and Open Questions

### Contradiction 1: [Title]
**Status:** RESOLVED / UNRESOLVED
[Description and resolution attempt]

### Open Question 1: [Title]
[What remains unknown and why]

## Source Registry

| # | Source | Type | Credibility Score | Key Contribution |
|---|--------|------|-------------------|------------------|
| 1 | [ref]  | [type] | [X/20]          | [what it provided] |
| 2 | ...    |        |                  |                    |

## Methodology Notes
[Any deviations from standard research process, scope expansions,
or diminishing returns events]

## Recommendations
[Actionable recommendations based on findings, ordered by confidence level]
```

## Examples

### Example 1: Surface Scan Output

**Research Question:** "What are the security implications of using WebAssembly
for server-side plugin systems?"

**Surface Scan Result:**
```
TAXONOMY:
├── WebAssembly Security Model
│   ├── Sandboxing guarantees
│   ├── Memory isolation
│   └── Capability-based security
├── Server-side WASM Runtimes
│   ├── Wasmtime (Bytecode Alliance)
│   ├── Wasmer
│   └── WasmEdge
├── Plugin System Architectures
│   ├── Interface types / WIT
│   ├── Host function exposure
│   └── Resource limits
└── Known Attack Vectors (GAP — needs Layer 2)
    ├── Side-channel attacks?
    ├── Host function abuse?
    └── Memory safety edge cases?

KEY TERMS: WASI, WIT, component model, linear memory, table imports,
host functions, capability-based security, fuel metering

KNOWLEDGE GAPS:
1. Real-world attack surface of WASM plugins (theoretical vs. demonstrated)
2. Performance overhead of sandboxing for latency-sensitive workloads
3. Comparison with alternative isolation (containers, V8 isolates, Lua)
```

### Example 2: Claim Extraction and Cross-Referencing

**Sub-topic:** WASM sandboxing guarantees

```
CLAIM 1: "WebAssembly provides memory isolation through linear memory — each
module gets its own address space with bounds checking."
Source: WebAssembly specification (credibility: 20/20)
Evidence type: Specification (theoretical)
Cross-reference: Confirmed by Bytecode Alliance docs (19/20), academic paper
  "Not So Fast: Analyzing the Performance of WebAssembly vs. Native Code" (17/20)
Confidence: HIGH

CLAIM 2: "Spectre-style side-channel attacks can bypass WASM sandboxing."
Source: Google Project Zero blog post, 2021 (18/20)
Evidence type: Empirical (demonstrated exploit)
Cross-reference: Partially contradicted by Bytecode Alliance response claiming
  mitigations in Wasmtime 0.33+
Confidence: MEDIUM (mitigations exist but completeness is unverified)

CLAIM 3: "WASM is inherently safer than native plugins."
Source: Blog post by WASM advocacy group (8/20)
Evidence type: Anecdotal
Cross-reference: No independent confirmation. Multiple sources note that host
  function exposure can negate sandboxing benefits.
Confidence: LOW (overly broad claim, context-dependent)
```

### Example 3: Contradictions Log

```
CONTRADICTION #1:
Claim A: "WASM fuel metering provides reliable resource limiting"
  Source: Wasmtime documentation (17/20)
Claim B: "Fuel metering overhead makes it impractical for hot-path operations"
  Source: Performance benchmark study (15/20)

Resolution: Both are correct in context. Fuel metering works for coarse-grained
limits (total execution budget) but adds measurable overhead to tight loops.
Recommend: Use epoch-based interruption for hot paths, fuel for overall budgets.
Status: RESOLVED
Confidence in resolution: MEDIUM
```

### Example 4: Diminishing Returns Event

```
DIMINISHING RETURNS DETECTED on sub-topic: WASM memory isolation
Reason: Redundancy threshold — last 3 sources (Fastly blog, CNCF presentation,
Mozilla wiki) all repeated the same linear memory isolation description with
no new evidence or nuance.
Current confidence: HIGH for basic isolation claims, MEDIUM for edge cases
Decision: STOP — redirect remaining budget to "Known Attack Vectors" sub-topic
which is at LOW confidence.
```

### Example 5: Evaluating a Source with Potential Bias

```
SOURCE EVALUATION:
Title: "Why You Should Use [Product X] for WASM Plugins"
Author: CTO of [Product X company]
Published: Company blog

Credibility Scoring:
- Authority: 4/5 (genuine technical expertise)
- Recency: 5/5 (published this year)
- Evidence: 3/5 (includes benchmarks, but only against competitors they beat)
- Independence: 1/5 (direct financial incentive to promote product)
Total: 13/20

Decision: Use for technical details about their approach, but do NOT use their
competitive benchmarks as evidence. Cross-reference any claims about competitors
with independent sources.
```

## Guidelines

1. **Never skip Layer 1.** The surface scan takes 20% of your time but prevents
   50% of wasted effort. Without a taxonomy, you will research chaotically and
   miss critical sub-topics.

2. **Three sources or it's not a finding.** A single source — no matter how
   credible — is a data point, not a finding. Two sources are a pattern.
   Three sources are evidence.

3. **Confidence levels are mandatory.** Every claim in your final report must have
   a confidence level. "I'm not sure" is more useful than false certainty.

4. **Contradictions are valuable.** Don't try to eliminate contradictions by
   ignoring the weaker source. Document them, attempt resolution, and if
   unresolvable, present both sides.

5. **Respect your time budget.** Research is infinite; your time is not. Use the
   diminishing returns detection actively. A research report delivered on time
   with MEDIUM confidence is more valuable than a perfect report delivered never.

6. **Separate facts from interpretations.** In your report, clearly distinguish
   between "Source X says Y" (fact about the source) and "Y is true" (your
   interpretation after cross-referencing).

7. **Progressive disclosure in output.** Lead with the executive summary and key
   findings. Put methodology notes, full source evaluations, and raw claim logs
   in appendices. Readers should get value from the first 20% of the report.

8. **Re-read the research question before writing your conclusion.** Drift is
   the most common failure mode. Your synthesis must answer the question that
   was asked, not the question you find most interesting.

9. **When in doubt about scope, stay narrow.** It is better to deeply answer a
   narrow question than to shallowly address a broad one. You can always do a
   follow-up research cycle.

10. **Cite everything.** Even obvious claims should have sources in a research
    report. This enables the reader to verify and builds the evidence chain that
    supports your confidence ratings.
