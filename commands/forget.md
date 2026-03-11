---
description: Find and delete a memory from the Obsidian vault with attribution-aware confirmation
allowed-tools: mcp__obsidian__*
---

Find and permanently delete a memory from the Obsidian vault. Shows full attribution before deletion for informed decisions.

**Usage:** `/forget <query>` or `/forget` (to be prompted)

## Instructions

1. If no query was provided, ask: "Which memory would you like to forget?"

2. Search for matching notes using `mcp__obsidian__obsidian_search`.

3. For each match, read frontmatter via `mcp__obsidian__obsidian_read` to extract attribution fields.

4. Present the matching notes with **full attribution context**:
   ```
   Found N matching memories:

   1. 📝 <filename>
      📁 <path> | 📅 <date>
      🤖 Stored by: <agent_name> (<agent_model>)
      🔗 Session: <session_id>
      📋 Type: <memory_type> | Keywords: <keywords>
      > <first 2–3 lines of content>

   2. 📝 <filename>
      ...
   ```

   - Always show `agent_name`, `agent_model`, and `session_id` for provenance
   - For legacy notes without attribution, show: "🤖 Stored by: unknown (pre-attribution)"
   - Number each result for easy selection

5. **Always confirm before deleting.** Ask:
   > "Are you sure you want to permanently delete `<path>`?
   > This memory was stored by **<agent_name>** (<agent_model>) on <date>.
   > This cannot be undone. (yes/no)"

6. If confirmed, delete using `mcp__obsidian__obsidian_manage_file` (action: "delete").

7. Confirm: "Memory deleted: `<path>` (was stored by `<agent_name>`)"

8. If the user says no or cancels, respond: "No memories were deleted."

## Safety Notes

- **Never delete without explicit confirmation** — show attribution so the user knows the provenance of what they're deleting
- If a memory has a `parent_memory_id` or is referenced by other notes, warn the user about potential broken links
- Deletion is permanent — there is no undo via the Obsidian MCP tools
