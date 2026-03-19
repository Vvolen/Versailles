# GitHub Actions Guide

**For non-developers — a plain-English explanation of how Actions work.**

---

## What Is GitHub Actions?

GitHub Actions is GitHub's built-in automation system. Think of it as a robot that lives in your repository and automatically runs tasks when certain things happen.

It's like having an assistant who:
- Wakes up every 6 hours to check GitHub for new tools
- Checks every new tool for security problems
- Tests skills automatically when they arrive
- Improves skills every night while you sleep

---

## What Is YAML?

YAML is the language used to write workflow files. It looks like this:

```yaml
name: My Workflow
on:
  schedule:
    - cron: "0 */6 * * *"
jobs:
  my-job:
    steps:
      - name: Say hello
        run: echo "Hello!"
```

**In plain English:** "Create a workflow called 'My Workflow'. Run it every 6 hours. It has one job that prints 'Hello!'"

You don't need to write or understand YAML to use Versailles. The workflows are already written. But if you ever want to read one, remember:
- Lines starting with `#` are comments (explanations for humans)
- Indentation (spaces) matters — it shows what belongs to what
- `${{ secrets.MY_SECRET }}` means "use the secret named MY_SECRET"

---

## How Cron Schedules Work

A cron schedule is a pattern that tells Actions when to run. It looks cryptic but follows a simple formula:

```
"minute  hour  day-of-month  month  day-of-week"
```

**Common examples:**

| Cron | Meaning |
|------|---------|
| `0 */6 * * *` | Every 6 hours (at 0:00, 6:00, 12:00, 18:00 UTC) |
| `0 2 * * *` | Every day at 2:00 AM UTC |
| `0 9 * * 1` | Every Monday at 9:00 AM UTC |
| `0 0 * * *` | Every day at midnight UTC |

**Important:** GitHub Actions uses UTC time (Greenwich Mean Time). 
If you're in New York (UTC-5 in winter / UTC-4 in summer due to daylight saving), the Scout runs at 7 PM, 1 AM, 7 AM, 1 PM EST (or 8 PM, 2 AM, 8 AM, 2 PM EDT).

---

## How Secrets Work

Secrets are sensitive values (API keys, passwords) stored securely by GitHub. They:
- Are **never** visible in logs, even to you
- Are only accessible to workflows you've authorized
- Are automatically redacted if accidentally printed

**Your secrets in Versailles:**

| Secret | What It Is | Where to Get It |
|--------|-----------|-----------------|
| `GITHUB_TOKEN` | GitHub access | Automatically provided — you don't need to set this |
| `ANTHROPIC_API_KEY` | Claude API access | [console.anthropic.com](https://console.anthropic.com) |

**In workflow files**, secrets look like: `${{ secrets.ANTHROPIC_API_KEY }}`

This tells the workflow: "Get the value of the secret named ANTHROPIC_API_KEY and use it here."

---

## How to Manually Trigger a Workflow

Most Versailles workflows run automatically, but you can trigger any of them manually:

1. Go to the **Actions** tab in your repository
2. Find the workflow in the left sidebar (e.g., "🔭 Scout")
3. Click the workflow name
4. You'll see a button: **Run workflow**
5. Click it → a dropdown appears
6. Optionally fill in any inputs (like a custom search query for Scout)
7. Click the green **Run workflow** button

The workflow will start within a few seconds. You can watch the progress live.

---

## How the Coding Agent (Copilot) Picks Up Issues

When you create an Issue using one of the Versailles templates, here's what happens:

1. **You create the issue** — fills in the template, adds a label
2. **Label triggers the workflow** — `research-request` label → research.yml fires
3. **Agent reads the issue** — extracts topic, depth, format from issue body
4. **Agent does the work** — researches, evaluates, or evolves
5. **Agent commits results** — directly to the branch
6. **Agent creates a PR** — with the findings
7. **Agent comments on your issue** — with a summary and link to results

This is **Issue-driven development**: you write the problem statement, the agent writes the solution.

---

## Understanding Workflow Triggers

Each workflow in Versailles uses one or more triggers (`on:` in YAML):

| Trigger | When It Fires | Used By |
|---------|--------------|---------|
| `schedule` | On a cron schedule | Scout, Evolver |
| `push` with `paths` | When specific files are pushed | Bouncer (discovered/), Evaluator (evaluated/), Self-Heal |
| `issues: labeled` | When an issue gets a label | Researcher |
| `workflow_dispatch` | Manual trigger from UI | All workflows |

---

## Reading Workflow Logs

When you click a workflow run, you see a tree of jobs and steps. Click any step to expand it.

**Status indicators:**
- ✅ Green checkmark = step succeeded
- ❌ Red X = step failed
- ⏭️ Gray = step was skipped
- 🟡 Spinning = step is running

**Reading a failed step:**
```
Error: Process completed with exit code 1.

From the log above, the actual error will appear:
  FileNotFoundError: skills/evaluated/missing-file.md
  → The file doesn't exist yet
```

Most failures in Versailles are either:
1. Missing `ANTHROPIC_API_KEY` secret
2. GitHub API rate limit (wait 1 hour)
3. Empty skills directory (nothing to process)

---

## Workflow Permissions

Each workflow declares what it's allowed to do:

```yaml
permissions:
  contents: write    # Can commit and push files
  issues: write      # Can create/comment on issues  
  pull-requests: write  # Can create PRs
```

Versailles workflows use only what they need. Self-Heal, for example, only has `contents: read` because it only reads files, never writes.

---

## Concurrency Settings

Some workflows have concurrency rules to prevent conflicts:

```yaml
concurrency:
  group: scout
  cancel-in-progress: false
```

This means: "Only one Scout can run at a time. If a new Scout tries to start while one is already running, it waits."

This prevents two Scouts from discovering the same tool simultaneously and creating duplicate entries.

---

## Workflow File Locations

All workflow files are in `.github/workflows/`:

```
.github/workflows/
├── scout.yml       # 🔭 Discovery
├── bouncer.yml     # 🛡️ Security
├── eval.yml        # 🧪 Evaluation
├── evolve.yml      # 🧬 Evolution
├── research.yml    # 🔬 Research
└── self-heal.yml   # 🏥 Integrity
```

You can view any of these files in the GitHub web interface to read the comments (lines starting with `#`) which explain what each step does in plain English.

---

*For hands-on usage: see [GETTING_STARTED.md](GETTING_STARTED.md)*
