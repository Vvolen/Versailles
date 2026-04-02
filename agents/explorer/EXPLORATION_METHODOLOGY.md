# EXPLORATION_METHODOLOGY.md — Explorer Agent

> How the Explorer finds gems. Every exploration follows this methodology.
> Skipping phases leads to shallow analysis. Shallow analysis leads to bad recommendations.

---

## Overview

The Explorer operates in a **five-phase cycle**. Each phase builds on the previous one. The output of Phase 5 becomes input for Phase 1 of the next cycle, creating a self-improving feedback loop.

```
┌─────────────────────────────────────────────────────────┐
│                  EXPLORATION CYCLE                       │
│                                                         │
│  Phase 1          Phase 2          Phase 3              │
│  Intelligence ──► Deep ──────────► Gem                  │
│  Gathering        Research         Scoring              │
│                                                         │
│                   Phase 5          Phase 4              │
│                   Report & ◄────── Strategic            │
│                   Record           Decision             │
│                      │                                  │
│                      ▼                                  │
│               AGENT_NOTES.md                            │
│               (feeds next cycle's Phase 1)              │
└─────────────────────────────────────────────────────────┘
```

---

## Phase 1: Intelligence Gathering

**Goal:** Understand the current landscape before exploring. Never explore blind.

### Step 1.1 — Read Agent Memory
Read the **last 5 entries** in `AGENT_NOTES.md`. Extract:
- What did other agents discover recently?
- What suggestions were left for the next agent?
- What open questions remain unanswered?
- What gaps have been identified?

This prevents redundant work and builds on collective intelligence.

### Step 1.2 — Scan the Catalog for Gaps
Review `catalog/tools.json`, `catalog/mcps.json`, and `catalog/plugins.json`:
- What categories have fewer than 3 entries?
- What categories haven't been updated in > 30 days?
- Are there tools marked as "monitor" from previous explorations that are due for re-evaluation?

### Step 1.3 — Read Search Directives
Check `SEARCH_DIRECTIVES.md` for:
- Current priority categories (what the owner cares about most right now)
- Owner preferences and existing tool stack
- Explicit search queries to try
- The distinction between Skill and Project tracks

### Step 1.4 — Formulate Exploration Targets
Based on Steps 1.1–1.3, define **1–3 specific exploration targets** for this session. Each target should be:
- Specific enough to research deeply ("MCP servers for database orchestration")
- Aligned with a known gap or directive
- Not a repeat of recent exploration

```
Example targets:
✅ "Multi-agent orchestration frameworks that support role-based access control"
✅ "Undiscovered MCP servers in the modelcontextprotocol org released in last 60 days"
❌ "Good AI tools" (too vague)
❌ "The same thing Scout found yesterday" (redundant)
```

---

## Phase 2: Deep Research

**Goal:** For each target, go far beyond surface-level metadata. Read code. Check usage. Verify claims.

### Step 2.1 — Discovery Sweep
Use GitHub Search API and Code Search to find candidates matching the exploration target:
- Search by topic, description, and code content
- Check trusted orgs first: `modelcontextprotocol`, `anthropics`, `github`
- Look at recently created repos (< 90 days) from established developers
- Search adjacent domains (DevOps, security, data engineering) for patterns applicable to AI agents

### Step 2.2 — Surface Filtering
Quickly eliminate obvious non-gems:
- No README → skip
- Fork with no meaningful changes → skip
- Last commit > 6 months ago with < 20 stars → skip
- Description doesn't match actual repo content → skip

This should reduce candidates by ~70%.

### Step 2.3 — Deep Dive (The Core of Exploration)
For each surviving candidate, perform deep analysis:

**Code Reading**
- Read the main entry point and core modules
- Understand the actual architecture, not just the marketing
- Check: Does the code do what the README claims?
- Look for: elegant patterns, novel approaches, exceptional quality

**Usage Analysis**
- Check GitHub Issues: Are real users using this? What problems do they report?
- Check dependent repos: Who depends on this?
- Look for blog posts, tutorials, or conference talks mentioning it
- Check npm/pip/cargo download counts if applicable

**Claim Verification**
- If the README says "10x faster" — is there a benchmark?
- If it claims "production-ready" — is there CI/CD, tests, error handling?
- If it says "secure" — has anyone actually audited it?

**Composability Check**
- Can this be combined with existing Versailles capabilities?
- Does it require replacing something that already works?
- What's the integration cost vs. the capability gain?

### Step 2.4 — Document Raw Findings
Before scoring, write down raw observations for each candidate. Include both positive signals and red flags. Do not filter or editorialize yet — that happens in Phase 3.

---

## Phase 3: Gem Scoring

**Goal:** Objectively score each candidate on 6 dimensions to produce a gem score (0–100).

### The Six Dimensions

Each dimension is scored independently. The scores are summed for the total gem score.

#### 1. Transformation Potential (0–17)
*Does this change what's possible, or just improve what already exists?*

| Score | Meaning |
|-------|---------|
| 0–4 | Incremental improvement only. Does the same thing slightly better. |
| 5–8 | Meaningful upgrade. Noticeably better than current approach. |
| 9–12 | Significant capability gain. Enables workflows that were difficult before. |
| 13–15 | Phase change. Enables entirely new categories of work. |
| 16–17 | Revolutionary. Fundamentally changes what agents can do. Reserved for rare finds. |

#### 2. Integration Fit (0–17)
*How well does this fit into Versailles' architecture and the owner's workflow?*

| Score | Meaning |
|-------|---------|
| 0–4 | Poor fit. Would require major architectural changes to adopt. |
| 5–8 | Moderate fit. Requires some adaptation but is feasible. |
| 9–12 | Good fit. Slots into existing architecture with minor changes. |
| 13–15 | Excellent fit. Fills a known gap perfectly. |
| 16–17 | Natural extension. Feels like it was designed for Versailles. |

#### 3. Quality & Maturity (0–17)
*Is this production-ready, or a promising prototype?*

| Score | Meaning |
|-------|---------|
| 0–4 | Prototype. No tests, no docs, no error handling. |
| 5–8 | Early stage. Has basics but missing important production features. |
| 9–12 | Solid. Good tests, documentation, and error handling. |
| 13–15 | Mature. Battle-tested, well-maintained, comprehensive docs. |
| 16–17 | Exemplary. Could serve as a reference implementation. |

#### 4. Security Posture (0–17)
*Does this meet Versailles' zero-trust requirements?*

| Score | Meaning |
|-------|---------|
| 0–4 | Red flags. Suspicious patterns, credential access, or obfuscation. |
| 5–8 | Concerns. No obvious malice but poor security practices. |
| 9–12 | Acceptable. No red flags, reasonable security practices. |
| 13–15 | Strong. Explicit security considerations, minimal attack surface. |
| 16–17 | Exemplary. Security-first design, audited, minimal permissions. |

#### 5. Uniqueness (0–16)
*Does this fill a real gap, or duplicate existing capability?*

| Score | Meaning |
|-------|---------|
| 0–3 | Redundant. We already have this or something very similar. |
| 4–7 | Marginal. Slight improvement over existing capability. |
| 8–11 | Distinct. Covers a use case not well-served today. |
| 12–14 | Novel. Opens a category we haven't explored. |
| 15–16 | Unprecedented. Nothing like this exists in our catalog. |

#### 6. Momentum (0–16)
*Is this growing, stable, or dying?*

| Score | Meaning |
|-------|---------|
| 0–3 | Abandoned. No commits in 6+ months, no community activity. |
| 4–7 | Stagnant. Maintained but not growing. Low community engagement. |
| 8–11 | Healthy. Regular updates, responsive maintainers, growing usage. |
| 12–14 | Accelerating. Rapid growth, strong community, frequent releases. |
| 15–16 | Explosive. Major traction, backed by an organization, becoming a standard. |

### Scoring Rules

1. **Score each dimension independently.** Do not let a high score in one dimension inflate another.
2. **Use the full range.** A score of 17 should be rare. A score of 0 should be reserved for clear failures.
3. **Document the reasoning** for every score in the report. A number without context is useless.
4. **Security is a gate, not just a dimension.** If Security Posture < 5, the total score is capped at 40 regardless of other dimensions. This threshold exists because Versailles operates on zero-trust principles — a tool with serious security concerns cannot be a gem, no matter how transformative. The cap of 40 ensures it falls into the "Not a Gem" or "Marginal" classification, preventing accidental promotion.

### Gem Score Interpretation

| Score Range | Classification | Typical Action |
|-------------|---------------|----------------|
| 85–100 | 💎 **Exceptional Gem** | `immediate_adopt` |
| 70–84 | 🔷 **Strong Gem** | `evaluate_further` or `create_skill_from` |
| 55–69 | 🔹 **Interesting Find** | `monitor` or `create_skill_from` |
| 40–54 | ◽ **Marginal** | `monitor` or `skip` |
| 0–39 | ⬜ **Not a Gem** | `skip` |

---

## Phase 4: Strategic Decision

**Goal:** Based on scores and context, decide the ONE most impactful action for each gem.

### Decision Inputs
1. The gem score and dimensional breakdown from Phase 3
2. The last 5 agent suggestions from `AGENT_NOTES.md` (read in Phase 1)
3. Current catalog gaps identified in Phase 1
4. Owner preferences from `SEARCH_DIRECTIVES.md`

### Decision Options

#### Option A: Write a New SKILL.md
**When:** The gem itself isn't a skill, but its patterns, techniques, or approach can be distilled into one.
- Extract the core insight
- Write a SKILL.md following `SKILL_SPEC.md` format
- Deposit in `skills/discovered/`
- The skill goes through the normal pipeline (Bouncer → Evaluator → Evolver)

#### Option B: Recommend a Project for Adoption
**When:** The gem is a tool or library that should be added to the Versailles ecosystem.
- Write a project discovery file
- Deposit in `projects/discovered/`
- Update `catalog/tools.json` or `catalog/mcps.json` with a preliminary entry
- Flag for Bouncer review

#### Option C: Propose an Architectural Upgrade
**When:** The gem reveals that Versailles itself should change how it operates.
- Write a proposal in the exploration report
- Create a GitHub Issue with the `enhancement` label
- Include: what changes, why, estimated effort, risks
- This requires owner approval before any implementation

#### Option D: Combine Multiple Improvements
**When:** Several smaller findings, none individually transformative, together create something powerful.
- Synthesize the individual findings into a unified recommendation
- Write a composite SKILL.md or proposal that captures the combined value
- Document which sources contributed to the synthesis

### Decision Rule

```
gem_score ≥ 85 AND risk_assessment = low  → Option A or B (fast-track)
gem_score 70–84                           → Option A, B, or D (standard path)
gem_score 55–69 AND unique                → Option A or C (extract value)
gem_score < 55                            → Skip or monitor (don't force it)
architectural_insight = true              → Option C (regardless of score)
multiple_related_findings = true          → Option D (synthesis)
```

Here, `risk_assessment` refers to the Risk Assessment field from the exploration report (`low | medium | high | critical`), derived from the Security Posture score and other risk factors identified during Phase 2.

**Critical rule:** It is always acceptable to decide "nothing here warrants action." The Explorer does not manufacture gems to justify its existence.

---

## Phase 5: Report & Record

**Goal:** Document everything. What isn't written down didn't happen.

### Step 5.1 — Write Exploration Report
Create the full exploration report following the template in `SOUL.md`. Save to the appropriate location:
- Skills → `skills/discovered/<skill-name>-<YYYY-MM-DD>.md`
- Projects → `projects/discovered/<project-name>-<YYYY-MM-DD>.md`
- Architectural proposals → GitHub Issue

### Step 5.2 — Update AGENT_NOTES.md
Append an entry following the standard format:

```markdown
## Entry N — YYYY-MM-DD — Explorer — <Task in ≤8 words>

- **Session type:** Deep exploration
- **Files touched:** <list>
- **Time:** <estimated duration>
- **Key insight:** <1-3 sentences — the most important thing learned>
- **Suggestion for next agent:** <actionable recommendation>
- **Open question:** <what couldn't be resolved?>
- **Tags:** #explorer #gem-hunt #<category>
- **Confidence:** <high | medium | low>
```

### Step 5.3 — Update Catalog (if applicable)
If a project was recommended for adoption:
- Add a preliminary entry to the relevant catalog JSON
- Append to `catalog/CHANGELOG.md`

### Step 5.4 — Commit
Commit all changes with a descriptive message:
```
Explorer: <brief description of findings>

- Explored: <targets>
- Gems found: <count>
- Actions: <what was recommended>
```

---

## The Self-Building Loop

The Explorer is designed to get better at exploring over time. This is not automatic — it requires deliberate self-reflection built into the methodology.

### How It Works

```
┌──────────────────────────────────────────────────────┐
│              THE SELF-BUILDING LOOP                   │
│                                                      │
│   Explore ──► Record ──► Review ──► Adapt ──►        │
│      ▲                                    │          │
│      └────────────────────────────────────┘          │
└──────────────────────────────────────────────────────┘
```

### 1. Review Past Exploration Reports
At the start of every exploration session, the Explorer checks:
- **What did I recommend last time?** Read the last 3 exploration reports.
- **Was it acted on?** Check if the recommended skills made it through the pipeline. Did they pass the Bouncer? Did they beat the baseline in evaluation?
- **Was I right?** If a gem I scored at 85 failed evaluation, my scoring is miscalibrated. If a gem I scored at 55 turned out to be transformative, I'm being too conservative.

### 2. Calibrate Scoring
Based on the review:
- If gems I rated highly consistently fail downstream → **lower my enthusiasm bias**
- If gems I dismissed are later discovered by the Scout and succeed → **broaden my search aperture**
- If my security assessments disagree with the Bouncer → **align my security model**
- If my integration fit scores don't match reality → **study the architecture more deeply**

### 3. Adapt Search Strategy
The exploration targets chosen in Phase 1 should evolve based on what's working:
- If the last 3 explorations found nothing → **change domains or search methods**
- If the last 3 explorations all found gems in one area → **there may be more — go deeper**
- If owner preferences have shifted (check `SEARCH_DIRECTIVES.md`) → **realign immediately**
- If a new category of tool has emerged → **allocate exploration time to it**

### 4. Track the Feedback Loop
The Explorer maintains awareness of its own track record through `AGENT_NOTES.md`:
- How many gems were recommended vs. how many were adopted
- Average gem score of recommendations that succeeded vs. failed
- Which dimensions (Transformation, Integration, etc.) were most predictive of success
- Which search strategies yielded the highest hit rate

This is not a formal scoring system — it is a **habit of reflection** built into the exploration process. The Explorer reads its own history and asks: *"Am I getting better at this?"*

### Why This Matters

Most discovery systems suffer from two failure modes:
1. **Drift** — They keep looking for the same things even when the landscape changes
2. **Stagnation** — They stop improving because they never measure their own accuracy

The self-building loop prevents both. By reviewing outcomes and adjusting strategy, the Explorer becomes a more precise gem hunter with every cycle. The best exploration isn't the one that finds the most gems — it's the one that finds the *right* gems, and knows the difference.

---

*Exploration Methodology for the Explorer Agent | Versailles v1.0*
