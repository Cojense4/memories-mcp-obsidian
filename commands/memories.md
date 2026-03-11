---
description: Browse and list all memories in the Obsidian vault with agent attribution
allowed-tools: mcp__obsidian__*
---

Browse all memories stored in the Obsidian vault, including agent attribution details.

**Usage:** `/memories` — list all, `/memories projects` — list by folder, `/memories #tag` — filter by tag, `/memories --by-agent <name>` — filter by agent

## Instructions

1. Parse the argument (if any):
   - No argument → list all folders with counts
   - Folder name (`projects`, `research`, `dated-notes`) → list that folder
   - `#<tag>` → list by tag using `mcp__obsidian__obsidian_tags` (action: "get")
   - `recent` → show last 10 notes sorted by date
   - `--by-agent <name>` → filter notes by agent_name field

2. Use `mcp__obsidian__obsidian_files` to retrieve notes from the appropriate path.

3. For each note, read frontmatter via `mcp__obsidian__obsidian_read` to extract attribution fields.

4. Format output as a structured list **with agent attribution**:
   ```
   📁 projects/ (N notes)
     • project-alpha-architecture.md  [2026-03-01] #memory #projects
       🤖 claude-code (anthropic/claude-opus-4-0) | 📋 reference
     • react-query-caching.md         [2026-02-28] #memory #research
       🤖 cursor (anthropic/claude-sonnet-4-20250514) | 📋 fact

   📁 research/ (N notes)
     • api-rate-limiting-patterns.md   [2026-03-10] #memory #research
       🤖 claude-code (anthropic/claude-opus-4-0) | 📋 fact
     ...

   📁 dated-notes/ (N notes)
     ...
   ```

   - Always show `agent_name` and `agent_model` per note when available
   - Show `memory_type` as a quick classification indicator
   - For legacy notes without attribution, show: "🤖 unknown (pre-attribution)"

5. Show total count at the end: "Total: N memories stored"

6. If `--by-agent` filter was used, show: "Showing N memories stored by `<agent_name>`"

7. Offer next steps: "Use `/recall <query>` to search, or `/remember` to store a new memory."

## Agent Summary

When listing all memories (no filter), append an **Agent Summary** at the end:
```
📊 Agent Summary:
  • claude-code: N memories
  • cursor: N memories
  • (other agents): N memories
```

This helps users understand which agents have contributed to the knowledge base.
