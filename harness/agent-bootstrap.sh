#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# agent-bootstrap.sh — Versailles Agent Startup Script
#
# Every agent that works in this repository runs this script (or mentally
# simulates it) before beginning its task. It sets up the environment,
# verifies dependencies, and confirms the agent is ready to operate.
#
# Usage:
#   bash harness/agent-bootstrap.sh [--role <scout|bouncer|evaluator|evolver|researcher>]
#
# For non-developers: This is like the pre-flight checklist a pilot runs
# before takeoff. It confirms everything is ready before work begins.
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

ROLE="${1:-unknown}"
if [[ "$1" == "--role" ]]; then
    ROLE="$2"
fi

echo "════════════════════════════════════════════"
echo "  🏰 Versailles Agent Bootstrap"
echo "  Role: ${ROLE}"
echo "  Date: $(date -u '+%Y-%m-%d %H:%M UTC')"
echo "════════════════════════════════════════════"
echo ""

# ── Step 1: Verify we're in the right repo ────────────────────────────────
echo "📁 Step 1: Verifying repository..."
if [ ! -f "CLAUDE.md" ]; then
    echo "  ❌ ERROR: CLAUDE.md not found."
    echo "     Are you running this from the repository root?"
    echo "     Expected: /workspaces/Versailles/harness/agent-bootstrap.sh"
    exit 1
fi
echo "  ✅ Repository confirmed (CLAUDE.md present)"

# ── Step 2: Check required environment variables ──────────────────────────
echo ""
echo "🔑 Step 2: Checking environment variables..."

MISSING_VARS=()

if [ -z "${GITHUB_TOKEN:-}" ]; then
    MISSING_VARS+=("GITHUB_TOKEN")
fi

# ANTHROPIC_API_KEY is optional at bootstrap (some agents don't need it)
if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
    echo "  ⚠️  ANTHROPIC_API_KEY not set (required for Evaluator and Evolver)"
else
    echo "  ✅ ANTHROPIC_API_KEY present"
fi

if [ ${#MISSING_VARS[@]} -gt 0 ]; then
    echo "  ⚠️  Missing variables: ${MISSING_VARS[*]}"
    echo "     Some workflows may fail. Add these to repo secrets:"
    echo "     Settings → Secrets and variables → Actions"
else
    echo "  ✅ GITHUB_TOKEN present"
fi

# ── Step 3: Verify directory structure ────────────────────────────────────
echo ""
echo "📂 Step 3: Verifying directory structure..."

REQUIRED_DIRS=(
    "skills/discovered"
    "skills/quarantine"
    "skills/evaluated"
    "skills/evolved"
    "skills/archive"
    "catalog"
    "research/topics"
    "research/findings"
    "agents/scout"
    "agents/bouncer"
    "agents/evaluator"
    "agents/evolver"
    "harness"
    "docs"
)

MISSING_DIRS=()
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        MISSING_DIRS+=("$dir")
    fi
done

if [ ${#MISSING_DIRS[@]} -gt 0 ]; then
    echo "  ⚠️  Creating missing directories: ${MISSING_DIRS[*]}"
    for dir in "${MISSING_DIRS[@]}"; do
        mkdir -p "$dir"
        touch "$dir/.gitkeep"
    done
    echo "  ✅ Directories created"
else
    echo "  ✅ All required directories present"
fi

# ── Step 4: Verify Node.js and Python ────────────────────────────────────
echo ""
echo "🛠️  Step 4: Checking runtime dependencies..."

if command -v node &>/dev/null; then
    NODE_VERSION=$(node --version)
    echo "  ✅ Node.js: $NODE_VERSION"
else
    echo "  ⚠️  Node.js not found (required for claude-flow)"
fi

if command -v python3 &>/dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "  ✅ Python: $PYTHON_VERSION"
else
    echo "  ❌ Python 3 not found (required for all workflows)"
    exit 1
fi

if command -v gh &>/dev/null; then
    GH_VERSION=$(gh --version | head -1)
    echo "  ✅ GitHub CLI: $GH_VERSION"
else
    echo "  ⚠️  GitHub CLI not found (required for PR creation in research workflow)"
fi

# ── Step 5: Check claude-flow (optional) ─────────────────────────────────
echo ""
echo "🤖 Step 5: Checking claude-flow..."

if command -v claude-flow &>/dev/null; then
    CF_VERSION=$(claude-flow --version 2>/dev/null || echo "version unknown")
    echo "  ✅ claude-flow: $CF_VERSION"
elif command -v npx &>/dev/null; then
    echo "  ℹ️  claude-flow not installed globally, but npx available"
    echo "     Run: npm install -g @claude-flow/cli@latest"
else
    echo "  ⚠️  claude-flow not available (required for swarm orchestration)"
fi

# ── Step 6: Load role-specific configuration ──────────────────────────────
echo ""
echo "🎭 Step 6: Loading role configuration..."

if [ "$ROLE" != "unknown" ] && [ -f "agents/$ROLE/SOUL.md" ]; then
    echo "  ✅ SOUL.md found: agents/$ROLE/SOUL.md"
    echo "  📖 Agent identity loaded"
else
    echo "  ⚠️  No specific role configured (run with --role <name> for role-specific setup)"
fi

# ── Step 7: Quick catalog health check ───────────────────────────────────
echo ""
echo "📊 Step 7: Catalog health check..."

TOOL_COUNT=$(python3 -c "
import json
try:
    with open('catalog/tools.json') as f:
        data = json.load(f)
    print(len(data.get('tools', [])))
except Exception:
    print('0')
" 2>/dev/null)

echo "  📦 Tools in catalog: $TOOL_COUNT"

EVOLVED_COUNT=$(find skills/evolved -name "*.md" ! -name ".gitkeep" 2>/dev/null | wc -l | tr -d ' ')
echo "  ⭐ Evolved skills: $EVOLVED_COUNT"

DISCOVERED_COUNT=$(find skills/discovered -name "*.md" ! -name ".gitkeep" 2>/dev/null | wc -l | tr -d ' ')
echo "  🔭 Pending discovery review: $DISCOVERED_COUNT"

# ── Ready ─────────────────────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════"
echo "  ✅ Bootstrap complete — agent ready"
echo ""
echo "  Next steps:"
echo "  1. Read CLAUDE.md (the agent constitution)"
if [ "$ROLE" != "unknown" ]; then
    echo "  2. Read agents/$ROLE/SOUL.md (your identity)"
fi
echo "  3. Check your assigned task"
echo "  4. Begin work"
echo "════════════════════════════════════════════"
