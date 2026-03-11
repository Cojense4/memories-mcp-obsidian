# Plugin Integrations Guide

This document describes how to use the Obsidian community plugins integrated with this memory vault. These plugins enable programmatic access, version control, similarity search, and AI agent interoperability.

---

## Installed Plugins

| Plugin | ID | Purpose |
|--------|-----|---------|
| MCP Tools | `mcp-tools` | Cross-agent MCP server access |
| Local REST API | `obsidian-local-rest-api` | HTTP API for external programs |
| Obsidian Git | `obsidian-git` | Auto-commit memory changes |
| Templater | `templater-obsidian` | Dynamic template variables |
| Smart Connections | `smart-connections` | AI-powered similarity search |

---

## 1. MCP Tools — Cross-Agent Access

**Plugin ID**: `mcp-tools`

### What it does
Exposes Obsidian vault operations as MCP (Model Context Protocol) tools, allowing any MCP-compatible agent (Claude Code, OpenCode, Cursor, etc.) to read/write memories directly.

### Available MCP Tools
| Tool | Description |
|------|-------------|
| `mcp__obsidian__obsidian_create` | Create a new memory note |
| `mcp__obsidian__obsidian_read` | Read a note's content and frontmatter |
| `mcp__obsidian__obsidian_write` | Replace note content entirely |
| `mcp__obsidian__obsidian_edit` | Append/prepend to existing note |
| `mcp__obsidian__obsidian_search` | Full-text search across vault |
| `mcp__obsidian__obsidian_tags` | Query by tag |
| `mcp__obsidian__obsidian_files` | List files/folders |
| `mcp__obsidian__obsidian_manage_file` | Move or delete notes |
| `mcp__obsidian__obsidian_properties` | Read/write frontmatter fields |
| `mcp__obsidian__obsidian_daily` | Interact with today's daily note |

### Usage in Claude Code / OpenCode
```yaml
# In .mcp.json or project config, ensure obsidian MCP server is listed:
{
  "mcpServers": {
    "obsidian": {
      "command": "...",
      "env": {}
    }
  }
}
```

### Commands that use MCP Tools
All `/remember`, `/recall`, `/memories`, and `/forget` commands use `mcp__obsidian__*` tools via the `allowed-tools: mcp__obsidian__*` declaration in each command file.

---

## 2. Local REST API — Programmatic HTTP Access

**Plugin ID**: `obsidian-local-rest-api`

### Configuration
- **HTTPS Port**: `27124`
- **HTTP Port**: `27123` (insecure, disabled by default)
- **API Key**: Set in `.obsidian/plugins/obsidian-local-rest-api/data.json`

### Base URL
```
https://localhost:27124
```

### Authentication
Include your API key in the `Authorization` header:
```
Authorization: Bearer <api-key>
```

> ⚠️ **Security Note**: The API key is in `data.json`. Do not commit this file to public repositories.

### Key Endpoints

#### List vault files
```bash
GET /vault/
```

#### Read a note
```bash
GET /vault/<path-to-note.md>
```
Example:
```bash
curl -k -H "Authorization: Bearer <key>" \
  "https://localhost:27124/vault/projects/my-project.md"
```

#### Create or update a note
```bash
PUT /vault/<path-to-note.md>
Content-Type: text/markdown

---
agent_name: claude-code
agent_model: anthropic/claude-opus-4-0
session_id: ses_abc123
memory_type: fact
keywords: [example, api, memory]
---

Note content here.
```

#### Search notes
```bash
POST /search/
Content-Type: application/json

{"query": "react hooks patterns", "contextLength": 200}
```

#### Append to active note
```bash
POST /active/
Content-Type: text/markdown

Additional content to append.
```

### Example: Create a Memory via REST API
```bash
#!/bin/bash
# create-memory.sh - Create a memory note via Local REST API

OBSIDIAN_API_KEY="your-api-key-here"
OBSIDIAN_URL="https://localhost:27124"
NOTE_PATH="projects/api-integration-notes.md"

curl -k -s -X PUT \
  -H "Authorization: Bearer ${OBSIDIAN_API_KEY}" \
  -H "Content-Type: text/markdown" \
  "${OBSIDIAN_URL}/vault/${NOTE_PATH}" \
  --data-binary @- << 'EOF'
---
tags: [memory, projects]
date: 2026-03-11
source: claude-code
agent_name: claude-code
agent_model: anthropic/claude-opus-4-0
session_id: ses_abc123
timestamp: 2026-03-11T10:00:00Z
memory_type: fact
keywords: [api, rest, integration]
embedding_model: nomic-embed-text
---

# API Integration Notes

Created programmatically via Local REST API.
EOF

echo "Memory created at: ${NOTE_PATH}"
```

---

## 3. Obsidian Git — Auto-Commit Memory Changes

**Plugin ID**: `obsidian-git`

### What it does
Automatically commits memory changes to Git, providing version history for all memories. This runs in the background within Obsidian.

### Configuration Location
`.obsidian/plugins/obsidian-git/data.json`

### Key Settings (Recommended)
```json
{
  "autoSaveInterval": 5,
  "autoPullInterval": 0,
  "commitMessage": "vault backup: {{date}}",
  "autoCommitMessage": "memory: {{hostname}} {{date}}",
  "commitDateFormat": "YYYY-MM-DD HH:mm:ss",
  "autoBackupAfterFileChange": true,
  "syncMethod": "rebase"
}
```

### Manual Git Operations for Agents
When an agent creates a memory via MCP Tools or REST API, it can trigger a Git commit manually:

```bash
# After creating a memory:
cd /path/to/vault
git add projects/new-memory.md
git commit -m "memory: add <topic> [agent: claude-code, session: ses_abc123]"
```

### Commit Message Convention for Agent Operations
```
memory: <brief description> [agent: <agent_name>, session: <session_id>]
```

Examples:
```
memory: add react-query caching strategy [agent: claude-code, session: ses_abc123]
memory: store daily summary 2026-03-11 [agent: opencode, session: conv_xyz789]
memory: update project architecture notes [agent: cursor, session: ses_def456]
```

### Git Integration in Commands
The `/remember` command documentation references Git commits after operations. Agents should include a `git commit` step after important memory writes, using the convention above.

### Hook into Post-Memory-Write
After any `obsidian_create` or `obsidian_write` call in a command, include:
```bash
# Optional: manual commit for important memories
git -C /Users/cjensen32/Documents/.memories add .
git -C /Users/cjensen32/Documents/.memories commit -m "memory: <description> [agent: <agent_name>]"
```

---

## 4. Smart Connections — Similarity Search

**Plugin ID**: `smart-connections`

### What it does
Uses AI embeddings to find semantically similar notes. Builds a local vector index of all memories and allows finding related memories by semantic similarity — not just keyword match.

### How to Use in Obsidian UI
1. Open a memory note in Obsidian
2. In the right sidebar, look for the **Smart Connections** panel
3. It shows similar memories ranked by semantic similarity

### How Agents Can Leverage It
Smart Connections builds its index automatically when Obsidian is running. Agents using the vault get the benefit of its pre-computed similarity data.

For programmatic similarity search, use **GrepAI** (see below) which provides the same semantic search capability via CLI.

### New Schema Fields Indexed
Smart Connections will automatically index all frontmatter fields when building its embeddings. The new schema fields that improve similarity matching:
- `keywords`: Explicitly boosts topical similarity
- `memory_type`: Groups similar types together
- `agent_name` + `agent_model`: Enables finding memories from the same agent

---

## 5. Templater — Dynamic Template Variables

**Plugin ID**: `templater-obsidian`

### What it does
Provides dynamic variables in template files. Used by templates in `templates/` to auto-fill dates, times, and other dynamic values.

### Template Files
| Template | Location | Use Case |
|----------|----------|----------|
| Daily Note | `templates/daily-note.md` | Session summaries, daily logs |
| Project Init | `templates/project-init.md` | New project memory spaces |
| Research Note | `templates/research-note.md` | Findings, library notes |

### Available Templater Variables
```yaml
# In frontmatter:
date: <% tp.date.now("YYYY-MM-DD") %>
timestamp: <% tp.date.now("YYYY-MM-DDTHH:mm:ssZ") %>

# In body:
Created: <% tp.date.now("dddd, MMMM D, YYYY") %>
```

### Agent Attribution Fields (Not auto-filled)
These must be provided by the agent at note creation time via MCP:
```yaml
agent_name: <provided by --agent-name parameter>
agent_model: <provided by --agent-model parameter>
session_id: <provided by --session-id parameter>
```

---

## 6. GrepAI — Semantic Search Optimization

**Configuration**: `.grepai/config.yaml`

### What it does
Provides semantic search using Ollama embeddings (`nomic-embed-text`). Searches by meaning, not just keywords. Integrated with MCP Tools via the `grepai_search` MCP.

### Configuration Highlights (Updated for Memory Vault)
- **Hybrid search enabled**: Combines semantic + keyword for best results
- **Memory folder bonuses**: `projects/` (+40%), `research/` (+40%), `dated-notes/` (+30%)
- **Command/template bonuses**: `commands/` (+20%), `docs/` (+20%)
- **Penalties**: `.obsidian/plugins` (−80%), `.claude/worktrees` (−70%)
- **Ignored**: `.obsidian/plugins`, `.obsidian/themes`, `.trash`

### Metadata Fields Indexed as Searchable Text
GrepAI indexes full file content including YAML frontmatter. All metadata fields are searchable:

| Field | Search Example |
|-------|---------------|
| `agent_name` | `grepai search "agent_name: claude-code"` |
| `agent_model` | `grepai search "agent_model: anthropic"` |
| `session_id` | `grepai search "session_id: ses_abc123"` |
| `memory_type` | `grepai search "memory_type: fact"` |
| `keywords` | `grepai search "keywords: react hooks"` |

### Search Commands
```bash
# Semantic search across all memories
grepai search "react query caching strategies"

# Search by agent attribution
grepai search "agent_name: claude-code memory_type: fact"

# Search within specific folder
grepai search "authentication patterns" --path projects/

# Get index status
grepai index status
```

### MCP-Based Search
From within agents, use:
```
mcp__grepai__grepai_search with query: "your search"
```

---

## Integration Matrix

| Use Case | Recommended Tool |
|----------|-----------------|
| Create memory from agent | MCP Tools (`obsidian_create`) |
| Read specific memory | MCP Tools (`obsidian_read`) |
| Search by keywords | MCP Tools (`obsidian_search`) |
| Semantic/meaning search | GrepAI (`grepai_search`) |
| Find similar memories | Smart Connections (UI) or GrepAI |
| Programmatic HTTP access | Local REST API |
| Version history | Obsidian Git (auto-commits) |
| Template-based creation | Templater + MCP Tools |

---

## Quick Reference: Memory Schema

Every memory note should include this frontmatter:

```yaml
---
tags: [memory, <category>]
date: YYYY-MM-DD
source: <agent_name>           # backwards compatibility
agent_name: <agent_name>       # e.g. claude-code, opencode, cursor
agent_model: <full_model_id>   # e.g. anthropic/claude-opus-4-0
session_id: <session_id>       # e.g. ses_abc123
timestamp: YYYY-MM-DDTHH:mm:ssZ
context_window_size: <tokens or empty>
temperature: <float or empty>
tool_calls_made: []
parent_memory_id: <id or empty>
keywords: [keyword1, keyword2, keyword3]
embedding_model: nomic-embed-text
memory_type: conversation|fact|instruction|reference
project: <project name or empty>
---
```

---

*Last updated: 2026-03-11*
*Maintained by: memory vault automation*
