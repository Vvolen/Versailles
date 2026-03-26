# modelcontextprotocol/servers — Official MCP Servers

**Category:** MCP Server
**Score:** 88/100
**URL:** https://github.com/modelcontextprotocol/servers
**Discovered:** 2026-03-26
**Status:** pending-bouncer-review

## Description
Reference implementations and community-contributed servers for the Model Context Protocol (MCP). This is the canonical collection of MCP servers maintained by the MCP organization. Includes servers for filesystem access, GitHub, Google Drive, PostgreSQL, Slack, memory, and many more.

## Why Scored 88/100
- ★16000+ (exceptional)
- Updated this week
- Has description
- Topics: mcp, model-context-protocol, servers
- 3000+ forks (exceptional)
- Active development with regular contributions
- Trusted org: modelcontextprotocol (official MCP project)

## Metadata
- **Stars:** 16000+
- **Forks:** 3000+
- **Language:** TypeScript
- **Topics:** mcp, model-context-protocol, servers
- **Last Updated:** 2026-03-26
- **Owner:** modelcontextprotocol
- **Is Fork:** false

## Key Capabilities
- Official reference implementations for MCP servers
- Filesystem server — safe file read/write
- GitHub server — search repos, manage issues, PRs
- Memory server — knowledge graph-based persistent memory
- Sequential thinking server — step-by-step reasoning
- Google Drive, Slack, PostgreSQL, and more
- Each server follows the MCP specification
- Well-documented with clear installation instructions

## Relevance to Versailles
Versailles already uses several MCP servers from this repo (filesystem, github,
sequential-thinking). This discovery serves as a catalog entry and validates the
existing MCP choices. The **memory server** is particularly interesting — it provides
a knowledge graph-based persistent memory that could complement the AGENT_NOTES.md
journal approach with structured, queryable memory.

## Bouncer Checklist
- [ ] Static analysis passed
- [ ] Reputation verified
- [ ] No credential harvesting patterns
- [ ] No unexpected network calls
- [ ] Approved for evaluation
