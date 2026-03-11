# Draft: MCP Obsidian Plugin for Shared AI Agent Memory

## Requirements (confirmed)
- [objective]: Create MCP plugin bridging Obsidian and AI agents (Claude Code/OpenCode)
- [purpose]: Enable shared memory management between AI agents using Obsidian as storage
- [current state]: Repository has .mcp.json config pointing to obsidian-mcp command

## Technical Decisions
- [pending]: Architecture pattern for MCP server
- [pending]: Memory organization structure in Obsidian
- [pending]: API design for memory operations

## Research Findings
- [explore agent]: Repository already has complete MCP-based memory system!
  - Uses external npm package: @theoryzhenkov/obsidian-mcp
  - Commands: /remember, /memories, /recall, /forget
  - Organized folders: projects/, research/, dated-notes/
  - Semantic search via GrepAI (ollama embeddings)
  - Session hooks for memory status
- [librarian agent]: MCP architecture recommendations:
  - Use TypeScript SDK with Resources (read), Tools (actions), Prompts (templates)
  - stdio transport for local agents, SSE for remote
  - Implement file locking for concurrent access
  - Hybrid search: BM25 (keyword) + Vector (semantic)
  - Consider Obsidian REST API bridge vs direct filesystem

## Current System Analysis
- **What exists**: Complete memory management system via obsidian-mcp
- **Integration**: .mcp.json → bun → obsidian-mcp → Obsidian vault
- **Commands**: Full CRUD operations on memories
- **Organization**: Categorized folders with frontmatter metadata
- **Search**: Both MCP tools and GrepAI semantic search

## Open Questions
- Do you want to ENHANCE the existing system or REPLACE it?
- What specific limitations are you hitting with current setup?
- Are other AI agents (beyond Claude) unable to use the current system?
- Do you need cross-agent memory sharing (agent A writes, agent B reads)?
- Should memories be agent-aware (track which agent created them)?
- Do you need real-time sync between multiple agents?
- What about memory versioning and conflict resolution?

## Scope Boundaries
- INCLUDE: [pending - need clarification on enhancement vs replacement]
- EXCLUDE: [pending - need user input]

## Architectural Options
1. **Enhance Current System**: Add features to existing obsidian-mcp
2. **Create Companion MCP**: New server alongside obsidian-mcp for agent coordination
3. **Replace with Custom**: Build new MCP server with expanded capabilities
4. **Multi-Agent Bridge**: MCP server that coordinates between multiple agent types