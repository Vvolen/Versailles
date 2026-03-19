# Codespaces Guide — Your Agentic Environment in the Browser

**How to use GitHub Codespaces as your full AI development environment.**

---

## What Is a Codespace?

A Codespace is a complete development environment that runs in your browser. When you open a Codespace in Versailles, you get:

- A browser-based VS Code editor
- A Linux computer running in GitHub's cloud
- Node.js 22 + Python 3.11 pre-installed
- `@claude-flow/cli` for multi-agent orchestration
- All MCP tools configured and ready
- GitHub Copilot and Copilot Chat available

You don't install anything locally. Close the browser, come back later, everything is where you left it.

---

## Opening Your Codespace

1. Go to your Versailles repository on GitHub
2. Click the green **Code** button
3. Click the **Codespaces** tab
4. Click **Create codespace on main**

GitHub will build the environment (~2 minutes the first time). When it's ready, you'll see VS Code in your browser.

---

## First Things to Do

### 1. Set Your API Key

The `GITHUB_TOKEN` is automatically available. For `ANTHROPIC_API_KEY`:

```bash
# Recommended: Use GitHub Codespaces secrets (most secure)
# Go to your GitHub profile → Settings → Codespaces → Secrets
# Add ANTHROPIC_API_KEY there — it will be auto-injected into all your Codespaces

# ⚠️  SECURITY WARNING: Do NOT store your API key in ~/.bashrc or any file
# in the repository. Use GitHub Codespaces secrets instead (see above).
```

### 2. Run the Bootstrap Script

```bash
bash harness/agent-bootstrap.sh
```

This verifies everything is set up correctly. You'll see:
```
════════════════════════════════════════
  🏰 Versailles Agent Bootstrap
  Role: unknown
  Date: 2026-03-19 09:00 UTC
════════════════════════════════════════

📁 Step 1: Verifying repository...
  ✅ Repository confirmed (CLAUDE.md present)

🔑 Step 2: Checking environment variables...
  ✅ ANTHROPIC_API_KEY present
  ✅ GITHUB_TOKEN present

[... more checks ...]

  ✅ Bootstrap complete — agent ready
```

---

## Using the Terminal

The terminal is at the bottom of the screen. Click on it or press `Ctrl+` ` (backtick) to open it.

**Useful commands:**

```bash
# Run the Scout manually (discover tools)
# (Usually you'd trigger this from GitHub Actions UI instead)
python3 .github/workflows/scout.yml  # Can't run workflows directly, 
                                       # but can run the Python code inside

# Check what skills have been discovered
ls skills/discovered/

# View the catalog
cat catalog/tools.json | python3 -m json.tool | head -50

# Check the changelog
cat catalog/CHANGELOG.md

# Run claude-flow to start a multi-agent session
claude-flow start

# View environment health
bash harness/agent-bootstrap.sh
```

---

## Working With Claude in Codespaces

GitHub Copilot Chat is available in your Codespace. Click the chat icon on the left sidebar (speech bubble).

**How to use it effectively:**

1. **Ask it to read a file first:** "Read CLAUDE.md and tell me what the 3-tier routing rules are"
2. **Reference specific files:** "@workspace what does the bouncer workflow do?"
3. **Request specific actions:** "Look at skills/discovered/ and tell me what tools were found"

The Copilot Chat in Codespaces has full access to your repository files, so it can give highly contextual answers.

---

## Running claude-flow

claude-flow is the multi-agent orchestration CLI, pre-installed in your Codespace.

```bash
# Check if claude-flow is installed
claude-flow --version

# Start an interactive session
claude-flow start

# Spawn a scout agent
claude-flow agent spawn scout \
  --task "Find top MCP servers for memory/storage" \
  --context "agents/scout/SOUL.md"

# Run a research task
claude-flow research \
  --topic "Solana trading bots and DeFi automation" \
  --depth 3 \
  --output "research/findings/solana-trading-2026-03-19.md"
```

---

## File Navigation

Your repository is at `/workspaces/Versailles/`. The left sidebar in VS Code shows all files.

**Quick navigation:**

| Press | To Do |
|-------|-------|
| `Ctrl+P` | Open any file by name (type partial name) |
| `Ctrl+Shift+F` | Search for text across all files |
| `Ctrl+` ` | Toggle terminal |
| `Ctrl+Shift+P` | Command palette (run any VS Code command) |

---

## Saving Your Work

Your Codespace auto-saves files. But you need to commit them to keep them after the Codespace is closed or times out.

```bash
git add .
git commit -m "my changes"
git push
```

Or use the VS Code Source Control panel (left sidebar, the branch icon).

---

## Managing Codespaces

Go to [github.com/codespaces](https://github.com/codespaces) to:
- See all your active Codespaces
- Stop a Codespace (to save compute minutes)
- Delete a Codespace (frees up storage)
- Change machine type (more RAM/CPU if needed)

**Copilot Pro Plus gives you generous Codespaces allowances.** You can run a Codespace for extended periods without hitting limits.

---

## MCP Tools in Codespaces

The `.mcp.json` configures which MCP servers are available. In a Codespace with claude-flow:

```bash
# claude-flow automatically reads .mcp.json
# These MCPs are available:
# - filesystem: read/write repo files
# - github: search repos, manage issues
# - context7: library documentation lookup
# - sequential-thinking: step-by-step reasoning

# Test that MCPs are loaded
claude-flow mcp list
```

---

## Resuming a Codespace

If you close your browser and come back:
1. Go to [github.com/codespaces](https://github.com/codespaces)
2. Click your Versailles Codespace
3. Everything is exactly where you left it

Codespaces save state automatically. Your terminal history, open files, and changes are preserved.

---

*Next: [DELEGATION_PLAYBOOK.md](DELEGATION_PLAYBOOK.md) — how to think like an architect*
