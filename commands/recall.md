---
description: Search memories in the Obsidian vault by keyword, tag, or project — with agent attribution
allowed-tools: mcp__obsidian__*
---

Search the Obsidian memory vault for relevant memories. Results include agent attribution metadata.

**Usage:** `/recall <query>` or `/recall` (to be prompted)

## Instructions

1. If no query was provided, ask: "What would you like to recall?"

2. Search using multiple strategies in parallel:
   - `mcp__obsidian__obsidian_search` with the query text
   - `mcp__obsidian__obsidian_tags` (action: "get") if the query looks like a tag or category

3. If the query mentions a project name, also search in `projects/<project-name>/` via `mcp__obsidian__obsidian_files`.

4. For each result, read the note's frontmatter to extract attribution fields using `mcp__obsidian__obsidian_read`.

5. Present results ranked by relevance with **attribution metadata**:
   ```
   📝 <filename>
      📁 <folder> | 📅 <date> | 🏷️ <tags>
      🤖 Stored by: <agent_name> (<agent_model>) | Session: <session_id>
      📋 Type: <memory_type> | Keywords: <keywords>
      > <short excerpt of content>
   ```

   - Group by folder (projects / research / dated-notes)
   - Always show `agent_name` and `agent_model` when present in frontmatter
   - For legacy notes without attribution fields, show: "🤖 Stored by: unknown (pre-attribution)"

6. If no results found, suggest: "No memories found for '<query>'. Try `/memories` to browse all notes."

7. Offer to open any result in full with `mcp__obsidian__obsidian_read`.

## Attribution Display Rules

- **agent_name** and **agent_model** are the primary attribution fields to display
- **session_id** provides traceability — show it for debugging/provenance
- **memory_type** and **keywords** help with relevance context
- If a note lacks new attribution fields (legacy), gracefully fall back to the `source` field or show "unknown"
