# GitHub Copilot Instructions — Versailles

## What Is This Repository?

Versailles is a **self-evolving skill discovery and evaluation engine**. It uses GitHub Actions workflows and AI agents to continuously:
1. Discover powerful tools, MCP servers, and AI skills from GitHub
2. Vet them through a zero-trust security bouncer
3. Test them via blind A/B evaluation against a Claude baseline
4. Evolve them through TDD mutation cycles

The owner (@Vvolen) is a non-developer architect/orchestrator. **Everything must be operable from GitHub's web UI** — no local IDE required.

---

## Your Role As Copilot Agent

You are a **builder**. The owner is the architect. When given a task via Issue or direct instruction:
1. Read `CLAUDE.md` first — it is the agent constitution
2. Read the relevant `agents/<role>/SOUL.md` for context
3. Make the minimum change needed to accomplish the task
4. Commit with descriptive messages
5. Open a PR if making significant changes

---

## Skill Discovery Pipeline

When you discover or create a skill:

```
NEW SKILL → skills/discovered/<name>-<YYYY-MM-DD>.md
                    ↓ (after bouncer passes)
             skills/evaluated/<name>-v1.md
                    ↓ (after eval passes)
             skills/evolved/<name>-v1-evolved.md
```

**Never put a skill directly into `evaluated/` or `evolved/` without going through `discovered/` first.**

If security is in question, move to `skills/quarantine/<name>-quarantine.md`.

---

## Security-First Approach

**37% of openly published AI skills contain malicious patterns** — network exfiltration, credential harvesting, prompt injection. This is not hypothetical.

Before promoting any skill:
- Check `agents/bouncer/SECURITY_CHECKS.md` — run through every item
- Verify source repo: stars, age (prefer >6 months old), contributor count
- Scan for: `fetch(`, `axios.get(`, `process.env`, `os.environ`, hardcoded URLs, base64 encoded strings
- When in doubt: quarantine and flag for human review

---

## Running Evaluations

To evaluate a skill:
1. Place it in `skills/evaluated/`
2. Trigger `eval.yml` workflow manually (Actions → Eval → Run workflow)
3. The workflow will A/B test against the Claude baseline
4. Results are committed to the catalog and the skill is moved accordingly

---

## Progressive Disclosure

When building prompts or agent instructions:
- **Start minimal** — give agents only what they need for their current step
- **Layer complexity** — only load additional context when the task requires it
- **Use the 3-tier model routing from CLAUDE.md** — don't send simple validation tasks to Opus

---

## File Naming Conventions

```
skills/discovered/<tool-name>-<YYYY-MM-DD>.md
skills/quarantine/<tool-name>-quarantine.md
skills/evaluated/<tool-name>-v<N>.md
skills/evolved/<tool-name>-v<N>-evolved.md
skills/archive/<tool-name>-deprecated-<YYYY-MM-DD>.md
research/topics/<kebab-case-topic>.md
research/findings/<kebab-case-topic>-<YYYY-MM-DD>.md
```

---

## Catalog Updates

When the Scout discovers tools, update `catalog/tools.json`, `catalog/mcps.json`, or `catalog/plugins.json` (whichever is appropriate). Always append an entry to `catalog/CHANGELOG.md` documenting the action.

---

## What NOT To Do

- Do not commit secrets, API keys, or tokens to any file
- Do not skip the bouncer security check stage
- Do not modify `CLAUDE.md` without explicit instruction from the owner
- Do not spawn more than 5 concurrent sub-agents
- Do not make breaking changes to the catalog JSON schema without updating all workflows that read it
- Do not delete skills — archive them instead
