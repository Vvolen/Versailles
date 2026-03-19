# Getting Started with Versailles

**For non-developers — no coding required.**

This guide explains how to use Versailles from GitHub's web interface. You don't need to install anything, open a terminal, or write code. Everything works from your browser at github.com.

---

## What Is Versailles?

Versailles is your **personal AI tool discovery and improvement engine**. It does three things automatically:

1. **Finds** the best AI tools and skills on GitHub (every 6 hours)
2. **Vets** them for security before they enter your toolkit
3. **Improves** them through automated testing and evolution

You are the **architect**. You decide what to research, what to focus on, and what to evolve. The agents do the actual work.

---

## The Delegation Model

```
YOU (Architect/Orchestrator)
  ↓  Create an Issue or trigger a workflow
AGENTS (Builders)
  ↓  Do the work, commit results
YOU
  ↓  Review the PR or check the results
```

You never write code. You write Issues. Agents write code.

---

## Step 1: Set Up Your Secrets (One-Time Setup)

Secrets are like passwords that GitHub stores securely. They're never visible in logs or code.

**You need two secrets:**

### ANTHROPIC_API_KEY (Required for Evaluator and Evolver)
1. Get your API key from [console.anthropic.com](https://console.anthropic.com)
2. In this repository, go to **Settings** (top menu, rightmost tab)
3. Click **Secrets and variables** → **Actions**
4. Click **New repository secret**
5. Name: `ANTHROPIC_API_KEY`
6. Value: paste your API key
7. Click **Add secret**

### GITHUB_TOKEN (Already exists!)
GitHub provides this automatically. You don't need to do anything. ✅

---

## Step 2: Trigger Your First Scout Run

The Scout discovers tools automatically every 6 hours, but you can trigger it manually right now:

1. Click the **Actions** tab (top navigation)
2. Find **🔭 Scout** in the left sidebar
3. Click **Run workflow** (right side)
4. Click the green **Run workflow** button
5. Watch the logs — the Scout is now searching GitHub for AI tools!

When it finishes, check:
- `skills/discovered/` — new tool files will appear here
- `catalog/tools.json` — the updated tool catalog
- `catalog/CHANGELOG.md` — what was found

---

## Step 3: Request Research on a Topic

Want to know everything about a specific topic? Create a Research Request Issue:

1. Click **Issues** tab
2. Click **New issue**
3. Choose **🔬 Research Request** template
4. Fill in:
   - **Topic:** What do you want researched? (e.g., "Best MCP servers for Solana blockchain data")
   - **Depth:** Standard (3 iterations) is usually enough
   - **Output format:** Full Report
5. Click **Submit**
6. The workflow automatically picks it up and starts researching
7. Check **Actions** to watch it work
8. A PR will appear with the completed research report

---

## Step 4: Evolve a Skill

Once the Scout has found tools and they've passed through the Bouncer (security check) and Evaluator (A/B testing), you can request evolution:

1. Check `skills/evolved/` for available skills
2. Click **Issues** tab → **New issue**
3. Choose **🧬 Skill Evolution Request**
4. Fill in the skill name and what you want improved
5. The Evolver picks it up automatically

---

## Step 5: Monitor What's Happening

### Actions Tab
Your command center. Shows:
- ✅ Green = workflow completed successfully
- ❌ Red = something failed (click to see why)
- 🟡 Yellow = workflow is running right now

Click any workflow run to see the detailed logs. Even if you can't read code, the logs have plain-English status messages.

### Files Tab
Browse the repository like a file manager:
- `skills/discovered/` — tools found in last Scout run
- `skills/evolved/` — production-ready skills
- `catalog/CHANGELOG.md` — chronological history of agent activity

### Pull Requests Tab
When the Researcher completes a report, it creates a PR. Review it here and merge when you're happy with the findings.

---

## How to Read Action Logs

When you click on a workflow run, you see a series of "steps" — each one is a task. Click any step to expand it.

**What to look for:**
- ✅ lines = success
- ❌ lines = failure (read the error message below)
- Numbers after `score:` = the scoring result

**Common log messages:**
```
✅ Scout complete: 12 new discoveries written     → Found 12 new tools
✅ PASSED (score: 73) → skills/evaluated/         → Bouncer approved this tool
❌ FAILED (score: 18) → quarantine                → Bouncer blocked this tool (suspicious)
✅ PROMOTED to evolved/ (+22.4% vs baseline)      → Tool beats raw Claude by 22%
```

---

## Workflow Quick Reference

| Workflow | How to Trigger | What Happens |
|----------|---------------|-------------|
| 🔭 Scout | Actions → Scout → Run | Searches GitHub, deposits in discovered/ |
| 🛡️ Bouncer | Auto (on push to discovered/) | Security-vets each discovery |
| 🧪 Evaluator | Auto (on push to evaluated/) | A/B tests against Claude baseline |
| 🧬 Evolver | Daily 2AM UTC, or Actions → Evolver → Run | Improves skills through TDD |
| 🔬 Researcher | Create issue with label "research-request" | Deep-dives on a topic |
| 🏥 Self-Heal | Auto (on every push) | Validates everything is intact |

---

## Opening a Codespace (Full Agent Environment)

If you want the complete agentic environment with claude-flow and all MCP tools:

1. Click the green **Code** button
2. Click **Codespaces** tab
3. Click **Create codespace on main**
4. Wait ~2 minutes for it to set up
5. You now have a full browser-based IDE with Node.js 22, Python 3.11, and claude-flow pre-installed

From here you can run `bash harness/agent-bootstrap.sh` to verify the environment is ready.

---

## Troubleshooting

### "Workflow failed immediately"
Most common cause: `ANTHROPIC_API_KEY` secret is missing or incorrect. Check **Settings → Secrets and variables → Actions**.

### "Scout found 0 discoveries"
The GitHub API has rate limits. Wait 1 hour and try again, or check the workflow logs for the specific error.

### "Bouncer quarantined everything"
The security thresholds are intentionally strict. Check `skills/quarantine/` — read the security reports and manually move files to `skills/evaluated/` if you're confident they're safe.

### "Evaluator archived a skill I wanted"
The 15% improvement threshold may be too strict for your use case. You can manually trigger `eval.yml` with `min_improvement: 5` as a workflow input.

---

*For deeper understanding: see [GITHUB_ACTIONS_GUIDE.md](GITHUB_ACTIONS_GUIDE.md) and [DELEGATION_PLAYBOOK.md](DELEGATION_PLAYBOOK.md)*
