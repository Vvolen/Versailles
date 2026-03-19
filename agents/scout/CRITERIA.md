# CRITERIA.md — Scout Scoring Rubric

> How the Scout scores discovered tools. Every dimension is 0–20 points. Maximum score: 100.

---

## Scoring Dimensions

### Dimension 1: Popularity / Social Proof (0–20)

Measures community adoption and trust signals.

| Stars | Score | Meaning |
|-------|-------|---------|
| 1,000+ | 20 | Exceptional — widely adopted |
| 500–999 | 16 | Strong — serious community |
| 100–499 | 12 | Good — proven usefulness |
| 20–99 | 8 | Modest — emerging |
| 5–19 | 4 | Low — very new or niche |
| 0–4 | 2 | Minimal — almost no signal |

**Trusted org bonus:** Tools from `anthropics`, `modelcontextprotocol` get +4 applied at Dimension 5.

---

### Dimension 2: Freshness / Maintenance (0–20)

Measures how actively maintained the tool is. Abandoned tools are a liability.

| Last Updated | Score | Meaning |
|-------------|-------|---------|
| Within 7 days | 20 | Actively developed |
| Within 30 days | 16 | Regular maintenance |
| Within 90 days | 12 | Reasonably current |
| Within 1 year | 8 | Aging but alive |
| Over 1 year | 2 | Likely stale |

---

### Dimension 3: Documentation Quality (0–20)

Well-documented tools are usable. Undocumented tools are traps.

| Signal | Points |
|--------|--------|
| Has a description (not empty) | +8 |
| Has topic tags (≥ 2) | +6 |
| Has wiki or GitHub Pages | +6 |

---

### Dimension 4: Activity / Health (0–20)

Measures ecosystem engagement beyond stars.

| Signal | Points |
|--------|--------|
| Forks ≥ 100 | +10 |
| Forks 20–99 | +7 |
| Forks 5–19 | +4 |
| Open issues 1–50 (healthy range) | +10 |
| Open issues 0 (might be abandoned or perfect) | +5 |
| Open issues > 200 (overwhelmed maintainer) | +0 |

---

### Dimension 5: Source Trust (0–20)

Not all GitHub accounts are equal. Trusted organizations get full credit.

| Signal | Points |
|--------|--------|
| From trusted org (anthropics, modelcontextprotocol) | 20 |
| Original repo (not a fork) | 10 |
| Fork of a trusted org's repo | 5 |
| Fork of unknown repo | 2 |

---

## Automatic Disqualifiers (Score = 0, Skip Discovery)

These patterns cause the Scout to skip a tool entirely:

- **Explicit malware indicators:** base64 payloads in README, obfuscated scripts
- **Zero stars + unknown owner + created < 7 days ago** (too new to trust)
- **Duplicate:** Already exists in `catalog/tools.json` with same URL
- **Fork with no meaningful additions** (description identical to parent)
- **No README at all** (minimum documentation bar)

---

## Score Thresholds

| Score | Action |
|-------|--------|
| 70–100 | ✅ High priority — auto-create discovery file + flag for immediate Bouncer review |
| 40–69 | ✅ Standard — create discovery file, normal Bouncer queue |
| 20–39 | ⚠️ Low priority — create discovery file but mark as low confidence |
| 0–19 | ❌ Skip — do not create discovery file |

---

## Examples

### High-Scoring Tool (Score: 88)

**Tool:** `modelcontextprotocol/servers`
- Stars: 5,000+ → **20 pts** (exceptional)
- Updated: 3 days ago → **20 pts** (active)
- Description + 8 topics → **14 pts** (documented)
- 200+ forks, 45 open issues → **20 pts** (healthy)
- Trusted org → **20 pts**
- **Slight penalty for being very large** → **-6 pts**
- **Total: 88/100**

### Medium-Scoring Tool (Score: 52)

**Tool:** `some-dev/claude-memory-helper`
- Stars: 87 → **12 pts** (good)
- Updated: 45 days ago → **12 pts** (reasonably current)
- Has description, 2 topics → **14 pts** (basic docs)
- 8 forks, 4 open issues → **8 pts** (modest)
- Not a fork, unknown developer → **10 pts** (original)
- **Total: 56/100** → rounded to 52 after bonuses/penalties

### Low-Scoring Tool (Score: 14)

**Tool:** `random-person/my-claude-prompts`
- Stars: 2 → **2 pts** (minimal)
- Updated: 8 months ago → **8 pts** (aging)
- No description → **0 pts**
- 0 forks, 0 issues → **5 pts** (no activity)
- Fork of another repo → **2 pts**
- **Total: 17/100** → Below threshold, skip

---

## Category-Specific Bonuses

When scoring by category, apply these additional modifiers:

| Category | Bonus Criteria | Bonus |
|----------|---------------|-------|
| MCP Server | Has working examples in README | +5 |
| Claude Skill | Includes eval scenarios or test cases | +5 |
| AI Agent | Has demo video or screenshots | +3 |
| Plugin | Has install count or marketplace listing | +5 |
| Library | Has >90% test coverage badge | +5 |

---

*Updated: 2026-03-19 | Used by: Scout workflow, scout.yml*
