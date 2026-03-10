---
description: Store a memory in the Obsidian vault with categorization and tags
allowed-tools: mcp__obsidian__*
---

Store a memory in the Obsidian vault. Categorize it and add frontmatter.

**Usage:** `/remember <content>` or `/remember` (to be prompted)

## Instructions

1. Ask the user what they want to remember if no content was provided.

2. Determine the appropriate folder:
   - `projects/` — project-specific knowledge, decisions, architecture
   - `research/` — findings, library notes, external knowledge
   - `dated-notes/` — session summaries, daily notes

3. Generate a short, descriptive filename (e.g., `react-query-caching-strategy.md`).

4. Create the note using `mcp__obsidian__create_note` with this frontmatter structure:
   ```yaml
   ---
   tags: [memory, <category>]
   date: <today's date>
   source: claude-code
   project: <project name if applicable, else omit>
   ---
   ```

5. After the main content, add a `## Context` section with the working directory and session context if relevant.

6. Confirm to the user: "Memory stored at `<folder>/<filename>.md`"
