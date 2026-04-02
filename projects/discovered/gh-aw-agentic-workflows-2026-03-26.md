# gh-aw — GitHub Agentic Workflows

**Category:** AI Agent
**Score:** 92/100
**URL:** https://github.com/github/gh-aw
**Discovered:** 2026-03-26
**Status:** pending-bouncer-review

## Description
Write agentic workflows in natural language markdown, and run them in GitHub Actions. GitHub Agentic Workflows (gh-aw) lets you author automated repository tasks as plain English Markdown files instead of complex YAML, specifying outcomes that an AI agent autonomously interprets and executes. Includes built-in security guardrails, sandboxed execution, network isolation, and compile-time validation.

## Why Scored 92/100
- ★4169 (exceptional)
- Updated this week
- Has description
- Topics: actions, cai, ci, claude-code, codex, copilot, gh-extension, github-actions
- 316 forks (popular)
- 165 open issues (healthy)
- Trusted org: github (official GitHub project)

## Metadata
- **Stars:** 4169
- **Forks:** 316
- **Language:** Go
- **Topics:** actions, cai, ci, claude-code, codex, copilot, gh-extension, github-actions
- **Last Updated:** 2026-03-26
- **Owner:** github
- **Is Fork:** false

## Key Capabilities
- Write workflows in natural language Markdown
- Compile Markdown intent files to runnable GitHub Actions YAML
- Built-in security: read-only permissions by default, sanitized safe-outputs
- Multiple layers of protection: sandboxed execution, input sanitization, network isolation
- Supply chain security with SHA-pinned dependencies
- Tool allow-listing and compile-time validation
- Human approval gates for critical operations
- CLI extension (`gh aw`) and VS Code extension support
- Companion projects: Agent Workflow Firewall (AWF), MCP Gateway

## Relevance to Versailles
This is directly relevant to Versailles's mission. gh-aw could replace or augment the
current YAML-embedded-Python workflow approach with natural language workflow definitions.
The security guardrails (network isolation, sandboxed execution) align with Versailles's
zero-trust security philosophy. Could be used to rewrite scout.yml, bouncer.yml, eval.yml,
and evolve.yml as Markdown intent files.

## Bouncer Checklist
- [ ] Static analysis passed
- [ ] Reputation verified
- [ ] No credential harvesting patterns
- [ ] No unexpected network calls
- [ ] Approved for evaluation
