---
description: Browse and list all memories in the Obsidian vault
allowed-tools: mcp__obsidian__*
---

Browse all memories stored in the Obsidian vault.

**Usage:** `/memories` — list all, `/memories projects` — list by folder, `/memories #tag` — filter by tag

## Instructions

1. Parse the argument (if any):
   - No argument → list all folders with counts
   - Folder name (`projects`, `research`, `dated-notes`) → list that folder
   - `#<tag>` → list by tag using `mcp__obsidian__list_notes_by_tag`
   - `recent` → show last 10 notes sorted by date

2. Use `mcp__obsidian__list_notes` to retrieve notes from the appropriate path.

3. Format output as a structured list:
   ```
   📁 projects/ (N notes)
     • project-alpha-architecture.md  [2026-03-01] #memory #projects
     • react-query-caching.md         [2026-02-28] #memory #research

   📁 research/ (N notes)
     ...
   ```

4. Show total count at the end: "Total: N memories stored"

5. Offer next steps: "Use `/recall <query>` to search, or `/remember` to store a new memory."
