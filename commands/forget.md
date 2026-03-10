---
description: Find and delete a memory from the Obsidian vault
allowed-tools: mcp__obsidian__*
---

Find and permanently delete a memory from the Obsidian vault.

**Usage:** `/forget <query>` or `/forget` (to be prompted)

## Instructions

1. If no query was provided, ask: "Which memory would you like to forget?"

2. Search for matching notes using `mcp__obsidian__search_notes`.

3. Present the matching notes clearly:
   - Show path, date, tags, and first 2–3 lines of content
   - Number each result

4. **Always confirm before deleting.** Ask:
   > "Are you sure you want to permanently delete `<path>`? This cannot be undone. (yes/no)"

5. If confirmed, delete using `mcp__obsidian__delete_note`.

6. Confirm: "Memory deleted: `<path>`"

7. If the user says no or cancels, respond: "No memories were deleted."
