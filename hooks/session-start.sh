#!/usr/bin/env bash
# Memory plugin session-start hook
# Outputs a brief status line about available memories

VAULT="/Users/cjensen32/Documents/.memories"
PROJECT=$(basename "$PWD" 2>/dev/null || echo "unknown")

# Count total memory files
TOTAL=$(find "$VAULT" -name "*.md" -not -path "*/.git/*" -not -path "*/templates/*" -not -path "*/.claude-plugin/*" 2>/dev/null | wc -l | tr -d ' ')

# Check if there's a project folder
PROJECT_COUNT=0
if [ -d "$VAULT/projects/$PROJECT" ]; then
  PROJECT_COUNT=$(find "$VAULT/projects/$PROJECT" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
fi

# Output context hint
if [ "$PROJECT_COUNT" -gt 0 ]; then
  echo "[memories] $TOTAL memories stored. Found $PROJECT_COUNT memories for '$PROJECT' — use /recall $PROJECT or /memories to browse."
elif [ "$TOTAL" -gt 0 ]; then
  echo "[memories] $TOTAL memories stored. Use /recall <query> to search or /memories to browse."
fi
# If 0 memories, output nothing (don't clutter new sessions)
