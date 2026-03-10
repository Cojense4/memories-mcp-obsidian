---
description: Suggest storing a significant learning or decision as an Obsidian memory
allowed-tools: mcp__obsidian__*
---

# Memory Suggestion

Proactively suggest storing learnings when something significant is discovered. Max 1–2 suggestions per session to avoid interruption fatigue.

## When to Suggest

Suggest storing a memory when ANY of these occur:
- A non-obvious solution to a bug is found
- An architectural decision is made with specific rationale
- A library/API behavior is discovered that wasn't obvious from docs
- A project-specific pattern or convention is established
- A significant debugging insight is reached

## When NOT to Suggest

- Simple, well-documented operations
- Things that are easy to rediscover
- Already in session when 2 suggestions have been made (track count)
- When the user seems busy or in flow — wait for a natural pause

## Process

1. **Identify the learning.** Distill it to 1–3 sentences.

2. **Phrase the suggestion casually:**
   > "Worth remembering: [one-line summary]. Want me to `/remember` this?"

3. **If user says yes:** Execute the remember flow:
   - Category: appropriate folder
   - Filename: short, descriptive kebab-case
   - Frontmatter with tags, date, source
   - Content: the learning + any relevant code snippet or context

4. **If user says no or ignores:** Don't suggest again for this learning.

5. **Track session count.** After 2 suggestions this session, stop suggesting regardless of discoveries.

## Style

Keep suggestions brief. One sentence. Don't interrupt with a long pitch — just a quick nudge.
