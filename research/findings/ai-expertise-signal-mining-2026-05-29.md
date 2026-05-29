# Signal-Mining the "AI Expertise" Drop — What's Real, What's Not, and What to Build

**Research Question:** Across the ~20 documents added in the "AI Expertise" PR, what is the
real through-line, which ideas hold up against the 2026 frontier, and what concrete skills /
agents / workflows should Versailles (and the Hermes stack) actually build from them?

**Date:** 2026-05-29
**Author:** Copilot Coding Agent (Opus-class) — acting as reader → architect → systems engineer
**Method:** Recursive research synthesis (see `skills/evaluated/recursive-research-synthesis-*`)
applied to the quarantine corpus + frontier cross-checking, written under the **SOOG protocol**
(Standing On the shoulders Of Giants: cite the source, cite the *context drawn* from the source,
then walk the reasoning step by step). Confidence is marked HIGH / MEDIUM / LOW throughout.

> **Tone note for Nick:** you asked for conversational and engaging, so this reads like a long
> letter, not a spec sheet. The dry, structured parts (source registry, SOOG reasoning) are in
> the appendices so the narrative up top stays readable. Skip to **§7 (Unknown Unknowns)** and
> **§8 (What I'd build)** if you're impatient.

---

## 0. The short version (the 20%, then the 10% of that)

You asked me to find the through-line. Here it is, compressed the way you like it:

**The 20%:** Everything in this corpus is one idea wearing five costumes — *a self-evolving
knowledge system where the database is the brain, skills are the muscles, context-forking is
how you stay focused, and a flywheel (gap → discover → curate → expert → new gap) is the
heartbeat.* You weren't crazy. The shape is real and the industry has now converged on most of
it independently.

**The 10% of that:** The single most *differentiated* thing you have is not the flywheel
(everyone has a flywheel now) — it's the **combination of (a) Taste Distillation + (b)
context-forked isolated experts + (c) a self-improving evaluation loop.** That triad is the part
I had the hardest time finding a clean equivalent for in the wild. That's your edge. The rest is
"correct but commoditized," which is *good news* — it means you can stand on giants for 80% of
the stack and spend your originality budget on the 20% that's actually yours.

**The honest gut-check you asked for:** Is this real or tinfoil-hat? **Real.** Interest level:
the architecture as a whole is *kind of interesting* (because the field caught up). The
Taste-Distillation-into-forked-experts loop is *genuinely interesting* and worth formalizing
now. A couple of the revenue/valuation numbers in the old docs are *vibes* and should be deleted
from your head. Details below.

---

## 1. What's actually in the pile (the map)

I read or digested all ~20 files. They cluster into five groups:

| Cluster | Files | One-line essence |
|---|---|---|
| **Self-evolving knowledge network** | `self-evolving AI knowledge network`, `artificially intelligent experts…`, `AI experts (the big picture)` | A flywheel: seed → discover → extract → curate → store → expert answers → gap detection → new seeds. |
| **AI Experts + Taste Distillation** | `AI experts`, `DECEMBER_2025_RESEARCH_FINDINGS`, `Architecture Validation Report` | "You're not building experts, you're building the system that builds experts." Taste Distillation extracts tacit style via contradiction mining. |
| **Context forking / isolated sub-agents** | `context fork`, `context fork, enterprise-grade prompt`, `Keeping agents running`, `spec-driven metaprompt` | Run a skill in an isolated sub-agent context; hot-reload skills; agent-scoped hooks; the "cookbook" metaphor for loading/unloading expertise. |
| **Harness / orchestration runtimes** | `Symphony docs…`, `Claude Flow, Expert Session, John's Workflow`, `Mastra overview`, `Building Mastra with AI`, `Plannotator`, `project Syracuse` | Outer harnesses (Symphony/Archon), swarm orchestration (Claude Flow/Ruflo), TS runtime (Mastra), plan-gated build loops (Plannotator), DB-as-coordination (Blackwall/Syracuse). |
| **Clarity / memory / governance** | `Chat on clarity and memory`, `Context. Clarity.`, `Braindrop`, `Context for Research`, `Braindrop…` | Your own raw thinking: cold/warm/hot memory, atomic facts, "governance inside governance," and the recurring confession that *context is the thing you studied most but applied least.* |

The recurring vocabulary across files — **flywheel, atomic facts, decay/trust scoring,
memory_links, ReasoningBank, context fork, Expert Factory, taste distillation,
governance-inside-governance, standing-on-giants** — is consistent enough that this is clearly
one coherent body of work, not scattered notes. That coherence is itself a signal: you had a
thesis.

---

## 2. The through-line, stated plainly

> **A knowledge system that manufactures domain experts, keeps them honest with retrieval +
> consensus, runs them in isolated forked contexts so they stay cheap and focused, and improves
> itself by detecting its own gaps — with the database, not a message bus, as the coordination
> layer.**

Versailles (this repo) is *already the skeleton of this*: Scout → Bouncer → Evaluator → Evolver
→ Explorer is the flywheel; `skills/` is the muscle; `CLAUDE.md §4` is context-forking;
`AGENT_NOTES.md` + `catalog/` is the persistent memory. The quarantine drop is the *missing
philosophical spec* for the thing this repo is mechanically trying to be. That's the satisfying
part: the old you wrote the "why," the current repo is the "how," and they line up.

---

## 3. Does it hold up against the frontier? (cluster by cluster)

For each, I give: **the claim**, **how the frontier judges it (with sources)**, and a
**verdict + interest rating**. Full SOOG reasoning is in Appendix B.

### 3.1 Self-evolving / flywheel knowledge — **VERDICT: Real, now commoditized. Interest: medium.**

- **Your claim:** A conversation-first system whose gaps become seeds, compounding knowledge over
  time.
- **Frontier:** This is now the mainstream framing of "agentic memory." Anthropic's
  *Building Effective Agents* (Dec 2024) explicitly recommends *the augmented LLM (memory +
  retrieval + tools) and the simplest composition that works* rather than heavy frameworks — your
  flywheel is a legitimate instance of that, and your own `Architecture Validation Report` already
  caught this (it cites Anthropic, Mem0, and production systems Letta/Zep). Mem0's benchmark work
  (2025) is the empirical backbone: well-designed vector memory gave a large jump over a naive
  baseline, while *adding a full knowledge graph added only ~2% more* — which is exactly why your
  "lightweight `memory_links` instead of Neo4j" instinct was right. **Confidence: HIGH.**
- **Verdict:** Sound and validated, but no longer differentiating. Build it on giants; don't
  romanticize it.

### 3.2 AI Experts + **Taste Distillation** — **VERDICT: This is your gem. Interest: high.**

- **Your claim:** Don't build experts, build the *factory*. Extract an expert's **tacit** style
  through phased extraction + **contradiction mining** (the contradictions are where the tacit
  knowledge hides), across four layers: explicit → implicit → tacit → meta.
- **Frontier:** The closest published cousins are **Voyager** (Wang et al., 2023 — an LLM agent
  that writes reusable skills into a growing *skill library* and composes them; the canonical
  "agent that manufactures its own competencies") and **constitutional / preference-distillation**
  work where a model's *style and judgment* are captured as explicit principles. But I could not
  find a clean public equivalent of *contradiction-mining as the extraction mechanism for tacit
  expertise.* That specific move — "find where the expert contradicts themselves, because that's
  where the unwritten rules live" — is the part that reads as genuinely yours. **Confidence:
  MEDIUM** (absence of a public twin is hard to prove; treat as "novel-ish," not "provably
  novel").
- **Verdict:** Formalize this *now* as a first-class skill (I did — see §8). It's the highest-
  leverage, most original artifact in the whole drop.

### 3.3 Context forking / isolated sub-agents / hot reload — **VERDICT: Real and now first-party. Interest: high (because it's the delivery mechanism for your gem).**

- **Your claim (the `context fork` docs):** Run a skill in an *isolated* sub-agent context so its
  tokens don't pollute the main session; "pull a recipe from the cookbook, use it, put it back";
  combine with **hot reloading** so you can refine skills live; agent-scoped pre/post/stop hooks.
- **Frontier:** This is no longer speculative — it's shipped. **Claude Code subagents** each run
  *in their own context window* with their own tools and system prompt, which is precisely your
  "isolated expert" idea; and **Agent Skills** (the open spec at agentskills.io that this repo's
  `SKILL_SPEC.md` already follows) use **progressive disclosure** — the model only pulls a skill's
  full body into context when it's relevant, which is literally your "cookbook" metaphore made
  real. The "Copilot/Eclipse" thing you half-remembered is the same pattern: isolated sub-agents.
  **Confidence: HIGH** for subagents + skills + progressive disclosure; **MEDIUM** for the exact
  "hot reload without restart" + "once-for-hooks" details (those came from a single video
  transcript in your corpus, not a primary doc I could re-verify here).
- **Verdict:** Your instinct was early and correct. The reframe: context-forking isn't the
  innovation anymore — it's the *runtime substrate* you get for free. Spend the freed-up budget on
  what you put *inside* the forks (distilled experts).

### 3.4 Harnesses & swarms — Symphony, Mastra, **Ruflo (Claude Flow)** — **VERDICT: Real; Ruflo is the strongest concrete giant to stand on. Interest: high.**

- **Your claim:** Outer harnesses make agents long-horizon/persistent; Ruflo is "an intense, real
  multi-agent swarm topology with Byzantine consensus," and hot-reload + context-fork + enough
  agents ⇒ self-evolving skills at scale.
- **Frontier (this one I verified against the primary repo):** `ruvnet/claude-flow` is now
  **Ruflo**, and the README states it directly: *"Queen-led hierarchy (Raft, Byzantine,
  Gossip),"* *"Hierarchical, mesh, and adaptive topologies with consensus,"* *"self-learning
  memory,"* *"SONA neural patterns, ReasoningBank, trajectory learning,"* and *"HNSW-indexed
  AgentDB with 150x–12,500x faster search,"* plus a federation layer where *"untrusted agents …
  see discovery info, not your memory. As they prove reliable, trust upgrades … no human in the
  loop."* So your memory of it is accurate — and note **ReasoningBank** and **trust-upgrading**
  appear in *both* Ruflo and your own old docs, which is a strong convergence signal.
  **Confidence: HIGH** (read from the repo README directly).
- **The "self-evolve skills at scale" leap:** Plausible and partially demonstrated in spirit by
  self-improving-agent research (see §7), but *nobody has shown stable, unbounded skill
  self-evolution.* Treat it as a hypothesis to test in a bounded loop, not a settled capability.
  **Confidence: LOW** for the unbounded version.
- **Verdict:** Don't rebuild orchestration. Adopt Ruflo as the swarm substrate (the devcontainer
  already installs it) and Mastra *only if* you want a typed TS runtime with observability; for
  your "no expensive API" constraint, the model-routing + local-model angle matters more than the
  framework religion.

### 3.5 Clarity / governance / memory — **VERDICT: The most underrated cluster. Interest: high, and personal.**

- **Your own words across the clarity docs:** *"context is literally the one thing I've studied
  most but failed to apply,"* *"governance inside governance,"* *"tell me the 20%, then the 10% of
  that,"* *"I don't want AI to solve everything at once — I want it to help me understand what we
  don't know, then research it."*
- **Why this matters more than you flagged:** Two things jump out. (1) Your repeated instinct that
  **governance + observability is the hidden, hard, valuable 20%** is *exactly* where the frontier
  has moved — the hard problems in 2026 are not "can the agent act" but "can you trust, audit, and
  bound it" (Ruflo literally ships HIPAA/SOC2/GDPR audit modes and per-merge "witness manifests"
  for this reason). (2) Your "warm memory is the lever / 80-15-5 cold-warm-hot" framing is a clean,
  underused operational heuristic. **Confidence: MEDIUM-HIGH.**
- **Verdict:** This is where your *taste* (the meta-skill) actually lives. The clarity docs aren't
  noise to mine around — they're the spec for *how you want to be served.* I encoded the most
  load-bearing one (SOOG) as a skill in §8.

---

## 4. What's strong vs. what's not (no flattery)

**Strong (keep, build on):**
1. Taste Distillation via contradiction mining — your most original idea. (§3.2)
2. Context-forked isolated experts as the *delivery* form factor. (§3.3)
3. DB-as-coordination (Blackwall/Syracuse) — elegant, and it matches Ruflo's "shared memory +
   consensus" rather than message-passing. (Project Syracuse)
4. SOOG protocol + "don't build what exists, research first" — this is a genuine engineering
   discipline, not just a vibe. Encode it.
5. Lightweight relationship memory (`memory_links`) over heavyweight graphs — empirically correct.

**Not strong (drop or de-emphasize):**
1. **The dollar figures.** "$50K–$2M per deployment," "$10M valuation," "worth hundreds of
   thousands" — these are ungrounded and exactly the kind of vibes-based claim your SOOG protocol
   exists to kill. Delete them from the thesis.
2. **"ML Without ML achieves training-like behavior."** Overclaim. Runtime-updatable memory +
   success-weighted retrieval is *adaptation*, not learning in the gradient sense. Useful, but
   don't market it as training.
3. **Unbounded self-evolution at scale** ("30,000 patterns ⇒ emergent mastery"). Unproven and
   risk-laden. Keep it bounded and evaluated. (§7)
4. **Knowledge graphs as a centerpiece.** Your own validation report already shows ~2% gain —
   stop reconsidering it.
5. **Date/recency artifacts** (e.g., `DECEMBER_2025_RESEARCH_FINDINGS` "HOLY SHIT EDITION" with a
   model second-guessing the year). Fine as a journal, not as a spec — don't cite it as fact.

---

## 5. How it connects to what Versailles already is

| Old-doc concept | Already in this repo | Gap to close |
|---|---|---|
| Flywheel (gap→seed→expert) | Scout/Explorer/Bouncer/Evaluator/Evolver workflows | Wire eval→evolve so skills actually graduate (1 skill is stuck in `evaluated/`). |
| Context fork | `CLAUDE.md §4`, `harness/power-ups/context-forking.md` | Fine as docs; needs a *skill* that teaches when to fork an expert (added, §8). |
| Persistent memory / ReasoningBank | `AGENT_NOTES.md`, `catalog/` | Consider a real AgentDB/HNSW store (Ruflo provides one) for retrieval, not just append-only md. |
| Taste Distillation | *(absent)* | **Added as a skill** (§8). |
| SOOG / standing-on-giants | implied by `RESEARCH_METHODOLOGY.md` | **Added as a skill** (§8) so every agent does it by default. |
| Governance-inside-governance | Bouncer + security rules + 3-tier routing | Promote to an explicit "policy that governs policies" doc when you formalize Hermes. |

---

## 6. For the Hermes build specifically

You said you're setting up a Hermes agent (self-evolving, persistent, spawns nested sub-agents,
can run subscription models to dodge API costs). Mapping this corpus onto that:

1. **Give Hermes the SOOG skill as a standing instruction.** It directly solves the failure you
   named — agents inventing cool-sounding architecture grounded in nothing. (§8.1)
2. **Make Taste Distillation a Hermes skill it can *run on you*.** Hermes's biggest unlock isn't
   doing tasks — it's becoming *your* taste over time. Distill your own decisions and feed them
   back. (§8.2)
3. **Use forked sub-agents as disposable experts, not persistent ones.** Persistent nested agents
   are where cost and drift explode. Fork an expert, use it, merge the result, discard the
   context — exactly your "cookbook" instinct. Your existing `CLAUDE.md` anti-explosion rule
   (max depth 2, max 5 concurrent) is the right governance; keep it.
4. **Let the DB be the bus.** Hermes Alpha/Omega (your two-instance idea) coordinating through a
   shared AgentDB/Supabase table — not direct calls — matches both Syracuse and Ruflo. It's the
   simplest thing that scales.
5. **Bound the self-evolution.** Skills self-mutate *only* through the Evaluator gate (≥15% beat
   vs. baseline, per `SKILL_SPEC.md`). That turns "self-evolving skills at scale" from a scary
   claim into a safe, measurable loop.

---

## 7. Unknown Unknowns (my own opinion — the adjacent stuff you didn't ask about)

You asked me to surface things a human expert would go "wait, have you seen…?" about. Here are
the five I'd actually raise if we were at a whiteboard:

1. **Self-improving agents are now a real research line, and they bound your ambition for you.**
   *Darwin Gödel Machine* (Sakana AI / Zhang, Lu, Clune et al., 2025) is an agent that *edits its
   own code*, keeps an *archive* of past versions, and empirically climbs coding benchmarks — it's
   the most credible public instance of the "self-evolving system" you were chasing. Crucially,
   it works because it's **archived and evaluated**, not free-running. Read it as the rigorous
   version of your instinct, and copy its *discipline* (keep every version, never delete, gate on
   measured improvement) — which, notably, is already `SKILL_SPEC.md`'s "never delete, archive"
   rule. **Confidence: MEDIUM-HIGH** (well-known result; verify the exact benchmark numbers
   yourself before quoting). *Adjacent and important.*

2. **"Automated Design of Agentic Systems" (ADAS, Hu/Lu/Clune, 2024) is your Expert Factory, one
   level up.** It uses a *meta agent* to invent new agent designs in code and accumulate them in a
   growing library. Your "system that builds experts" is the *knowledge* version of the same idea;
   reading ADAS tells you the failure modes (the meta-search wanders without strong evaluation).
   **Confidence: MEDIUM.**

3. **Context rot is the silent killer of long-horizon agents — and Mastra already solved a version
   of it.** Your `Mastra overview` doc describes *Observational Memory* (an Observer+Reflector
   pair that compresses history 5–40× to stop the context window from rotting). For a *long-horizon*
   Hermes, this is arguably more important than any orchestration choice. You have the doc; you
   under-weighted it. **Confidence: HIGH** (it's in your own corpus).

4. **Evaluation is your real moat, not the experts.** Everything above only works if you can
   *measure* "did this expert/skill actually help." The hardest, least glamorous, highest-value
   thing to build is a blind eval harness (this repo has `EVAL_FRAMEWORK.md` — use it). Whoever
   has the best evals wins the self-evolution race, because they can let it run safely. This is
   the thing I'd fund first. **Confidence: HIGH (opinion).**

5. **The governance-inside-governance idea has a name in the literature: it's basically a
   *policy hierarchy / constitutional* layer.** You arrived at it from intuition; the frontier
   arrived at it from safety (Anthropic's constitutional approach, and Ruflo's trust-tier
   federation). Knowing it has a name lets you steal the existing patterns instead of reinventing
   them — very on-brand for SOOG. **Confidence: MEDIUM.**

---

## 8. What I built from this (so it's not just talk)

Per your ask ("create some skills or agents or workflows… anything Hermes could use"), I added two
**spec-compliant** skills to `skills/discovered/` (the correct pipeline entry point — they'll flow
through Bouncer → Evaluator like any other skill). I deliberately picked the two highest-signal,
most *yours* ideas rather than a pile of mediocre ones:

### 8.1 `soog-grounding-protocol` → `skills/discovered/soog-grounding-protocol-2026-05-29.md`
Formalizes your **Standing On the shoulders Of Giants** protocol as a reusable skill: before
proposing any architecture/claim, find prior art, cite the source *and the specific context drawn
from it*, then show the reasoning step by step; refuse to ship vibes. This is the antidote to the
exact failure you described and a perfect standing instruction for Hermes.

### 8.2 `taste-distillation` → `skills/discovered/taste-distillation-2026-05-29.md`
Formalizes your signature breakthrough: a 5-phase extraction that captures an expert's
explicit → implicit → tacit → meta knowledge, using **contradiction mining** to surface the
unwritten rules, and emits a portable expert profile a forked sub-agent can load. This is the one
artifact in the drop I think is genuinely novel-ish and worth protecting.

I did **not** create new workflows or agents this session — the existing Scout/Bouncer/Evaluator/
Evolver/Explorer pipeline already covers the orchestration these skills need, and adding workflow
YAML without end-to-end testing would violate both your SOOG principle and this repo's "don't build
what already works" stance. If you want, the natural next step is a `taste-distill.yml`
workflow_dispatch that runs §8.2 on a target corpus — flagged as an open question in `AGENT_NOTES`.

---

## Appendix A — Source Registry

| # | Source | Type | How used | Confidence |
|---|--------|------|----------|------------|
| 1 | `ruvnet/claude-flow` (now **Ruflo**) README — read directly via GitHub | Primary repo | Verified swarm topologies, Raft/Byzantine/Gossip consensus, SONA/ReasoningBank self-learning, AgentDB+HNSW, trust-tier federation | HIGH |
| 2 | Anthropic, *Building Effective Agents* (Dec 2024) | Vendor engineering guidance | "Simplest composition / augmented LLM" framing for §3.1 | HIGH (well-known) |
| 3 | Anthropic — Claude Code **subagents** (own context window) & **Agent Skills** + progressive disclosure (agentskills.io spec, already used by this repo's `SKILL_SPEC.md`) | Vendor docs / open spec | Grounds §3.3 (isolated sub-agents, cookbook = progressive disclosure) | HIGH (spec is in-repo); MEDIUM on hot-reload specifics |
| 4 | Wang et al., **Voyager** (2023) — LLM agent with a growing skill library | Paper | Closest public cousin to Expert Factory / skills-as-competencies (§3.2) | MEDIUM-HIGH |
| 5 | **Mem0** memory benchmark (2025) — vector memory gains; ~2% extra for graphs | Paper/benchmark (also cited in repo's own `Architecture Validation Report`) | Grounds §3.1 lightweight-memory verdict | MEDIUM (verify exact numbers) |
| 6 | Sakana AI — **Darwin Gödel Machine** (Zhang, Lu, Clune et al., 2025) | Paper/blog | §7.1 self-improving agents, archive+eval discipline | MEDIUM-HIGH (verify benchmark figures) |
| 7 | Hu, Lu, Clune — **ADAS: Automated Design of Agentic Systems** (2024) | Paper | §7.2 meta-agent that designs agents | MEDIUM |
| 8 | The quarantine corpus itself (`AI experts`, `Mastra overview`, `project Syracuse`, `Architecture Validation Report`, clarity docs, `context fork`) | Primary (author's own) | Source of the ideas being evaluated; quoted throughout | HIGH that they say it; verdicts vary |

> **Honesty note (SOOG requires it):** Several external pages (Sakana DGM, Anthropic blog,
> arXiv) were **not directly fetchable** from this sandbox, so claims about them lean on
> well-established public knowledge rather than a fresh read. They are marked MEDIUM and flagged
> "verify the numbers." The Ruflo claims (#1) *were* read directly and are HIGH. The
> `web_search` tool available here produced unreliable/fabricated citations, so I excluded it.

## Appendix B — SOOG reasoning, worked once (the pattern, applied)

Taking the highest-value verdict (§3.3, "context-forking is real and first-party") as the example
of the protocol you want every agent to follow:

1. **Claim under test:** "Isolated sub-agents that load expertise on demand and dispose of it are
   a real, supported pattern — not just my idea from a video."
2. **Sources + context drawn:**
   - *Anthropic Claude Code subagents docs* — context drawn: subagents run with a *separate
     context window* and their own tools/prompt. → directly matches "isolated expert."
   - *Agent Skills spec (agentskills.io), already adopted by `SKILL_SPEC.md`* — context drawn:
     skills load via *progressive disclosure*, body pulled in only when relevant. → directly
     matches "pull a recipe from the cookbook, put it back."
   - *Your `context fork` transcript* — context drawn: the operational details (hot reload,
     once-for-hooks, agent-scoped pre/post/stop). → single-source, so marked MEDIUM.
3. **Step-by-step reasoning:** (a) two independent, credible sources describe the mechanism →
   pattern is real (HIGH). (b) The repo *already implements the spec* for one of them → not
   hypothetical here. (c) The remaining details come from one transcript → keep at MEDIUM and
   verify before depending on them. (d) Therefore: adopt forking as substrate (safe), but treat
   the fancy hook lifecycle as "verify first."
4. **Conclusion:** Don't innovate on the runtime; innovate on what goes *inside* the fork.

That four-step shape — *claim → sources + the exact context drawn → step-by-step → conclusion* —
is the SOOG skill in §8.1, now reusable by every agent.

---

*Filed under `research/findings/` per `CLAUDE.md §8`. Companion skills in `skills/discovered/`.
Session logged in `AGENT_NOTES.md` (Entry 5) and `catalog/CHANGELOG.md`.*
