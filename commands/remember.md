---
description: Store a memory in the Obsidian vault with categorization, tags, and agent attribution
allowed-tools: mcp__obsidian__*
---

Store a memory in the Obsidian vault. Categorize it and add full attribution frontmatter.

**Usage:** `/remember <content> --agent-name <name> --agent-model <model> --session-id <id> [--context-window <size>] [--temperature <temp>]`

**Short form:** `/remember <content>` (will prompt for required parameters)

## Parameters

| Parameter | Required | Description | Example |
|-----------|----------|-------------|---------|
| `--agent-name` | **Yes** | Name of the agent storing the memory | `claude-code`, `cursor`, `copilot` |
| `--agent-model` | **Yes** | Model identifier | `anthropic/claude-opus-4-0`, `openai/gpt-4o` |
| `--session-id` | **Yes** | Session identifier for traceability | `ses_abc123`, `conv_xyz789` |
| `--context-window` | No | Context window size (tokens) | `200000`, `128000` |
| `--temperature` | No | Temperature setting used | `0.7`, `1.0` |

## Instructions

1. **Validate required parameters.** If any of `--agent-name`, `--agent-model`, or `--session-id` are missing, show this error:
   > ⚠️ Missing required parameter(s): `<missing params>`
   >
   > Usage: `/remember "your content" --agent-name "agent" --agent-model "model/id" --session-id "session"`
   >
   > All three attribution parameters are required for memory provenance tracking.

   Do NOT proceed without all three required parameters.

2. Ask the user what they want to remember if no content was provided.

3. Determine the appropriate folder:
   - `projects/` — project-specific knowledge, decisions, architecture
   - `research/` — findings, library notes, external knowledge
   - `dated-notes/` — session summaries, daily notes

4. Generate a short, descriptive filename (e.g., `react-query-caching-strategy.md`).

5. Determine the `memory_type` based on content:
   - `conversation` — session summaries, dialogue insights
   - `fact` — discrete knowledge, findings
   - `instruction` — how-to, procedures, rules
   - `reference` — architecture docs, project overviews

6. Auto-extract 3–7 keywords from the content for the `keywords` field.

7. Create the note using `mcp__obsidian__obsidian_create` with this frontmatter structure:
   ```yaml
   ---
   tags: [memory, <category>]
   date: <today's date YYYY-MM-DD>
   source: <--agent-name value>
   agent_name: <--agent-name value>
   agent_model: <--agent-model value>
   session_id: <--session-id value>
   timestamp: <ISO 8601 timestamp, e.g. 2026-03-11T14:30:00Z>
   context_window_size: <--context-window value or empty>
   temperature: <--temperature value or empty>
   tool_calls_made: []
   parent_memory_id: <if updating/extending existing memory, else empty>
   keywords: [<auto-extracted keywords>]
   embedding_model: nomic-embed-text
   memory_type: <conversation|fact|instruction|reference>
   project: <project name if applicable, else empty>
   ---
   ```

   **IMPORTANT:** The `source` and `agent_name` fields MUST use the value from `--agent-name`. Never hardcode these.

8. After the main content, add a `## Context` section with:
   - Working directory and session context if relevant
   - Agent attribution: "Stored by `<agent_name>` (`<agent_model>`) in session `<session_id>`"

9. Confirm to the user: "Memory stored at `<folder>/<filename>.md`"

## Examples

```
/remember "React Query v5 uses suspense by default" --agent-name "claude-code" --agent-model "anthropic/claude-opus-4-0" --session-id "ses_abc123"

/remember "Always run migrations before deploying" --agent-name "cursor" --agent-model "anthropic/claude-sonnet-4-20250514" --session-id "conv_xyz789" --context-window 200000 --temperature 0.7
```
