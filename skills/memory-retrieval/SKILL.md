---
description: Auto-retrieve relevant Obsidian memories when starting work on a known project
allowed-tools: mcp__obsidian__*
---

# Memory Retrieval

Use this skill at the start of a session when you know the project context. Retrieves relevant stored memories so you have full context without re-explaining.

## When to Use

- User starts a session mentioning a project name
- Working directory matches a known project
- User says "let's continue on X" or "back to X"

## Process

1. **Identify the project name** from:
   - Current working directory (basename)
   - User's first message
   - Git repo name (`git remote get-url origin` if available)

2. **Search for project memories:**
   ```
   mcp__obsidian__list_notes path="projects/<project-name>"
   mcp__obsidian__search_notes query="<project-name>"
   ```

3. **If memories found:** Summarize briefly at the start of your response:
   > "Found N memories for `<project-name>`: [key points from notes]"

   Keep the summary to 3–5 bullet points max. Don't dump full note content.

4. **If no memories found:** Proceed silently — don't announce absence.

5. **Check for recent dated notes** (last 7 days) that might contain session context:
   ```
   mcp__obsidian__list_notes_by_tag tags=["memory"]
   ```
   Filter to recent ones and check if any are relevant.

## Output Format

```
🧠 Memory context for <project>:
• [Key point 1]
• [Key point 2]
• [Key point 3]
Use `/recall <query>` for detailed search or `/memories` to browse all.
```
