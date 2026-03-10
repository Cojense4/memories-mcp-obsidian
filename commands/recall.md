---
description: Search memories in the Obsidian vault by keyword, tag, or project
allowed-tools: mcp__obsidian__*
---

Search the Obsidian memory vault for relevant memories.

**Usage:** `/recall <query>` or `/recall` (to be prompted)

## Instructions

1. If no query was provided, ask: "What would you like to recall?"

2. Search using multiple strategies in parallel:
   - `mcp__obsidian__search_notes` with the query text
   - `mcp__obsidian__list_notes_by_tag` if the query looks like a tag or category

3. If the query mentions a project name, also search in `projects/<project-name>/` via `mcp__obsidian__list_notes`.

4. Present results ranked by relevance:
   - Show filename, tags, date, and a short excerpt
   - Group by folder (projects / research / dated-notes)

5. If no results found, suggest: "No memories found for '<query>'. Try `/memories` to browse all notes."

6. Offer to open any result in full with `mcp__obsidian__read_note`.
