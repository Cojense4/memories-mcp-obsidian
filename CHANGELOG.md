# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Agent attribution tracking for all memory notes
- Parameter-based agent detection in commands (--agent-name, --agent-model, --session-id)
- Enhanced metadata schema with 15+ fields for better indexing:
  - agent_name, agent_model, session_id, timestamp
  - context_window_size, temperature, tool_calls_made
  - parent_memory_id, keywords, embedding_model, memory_type
- Schema validation test script (tests/validate-schema.sh)
- Comprehensive shell test suite (13 tests across 4 scripts)
- Plugin integration documentation (docs/plugin-integrations.md)
- GrepAI configuration optimized for memory vault

### Changed
- Updated all templates (daily-note.md, project-init.md, research-note.md) with full attribution schema
- Updated all commands to accept and use agent parameters instead of hardcoded values
- Updated skills to reference new schema fields
- Enhanced .grepai/config.yaml for memory-specific indexing
- Commands now include Git auto-commit hooks and Smart Connections updates

### Fixed
- Removed .memories/.memories symlink loop that blocked recursive file operations
- Updated tool references in commands to match actual Obsidian MCP tool names

### Technical Details
- **Test Coverage**: 13/13 tests passing
- **Files Modified**: 30 files changed, 2365 insertions, 159 deletions
- **Backwards Compatibility**: Maintained existing 'source' field while adding new attribution fields
- **Schema Format**: Flat YAML structure compatible with Obsidian Properties panel

## [0.1.0] - 2026-03-11 - Initial Release

### Added
- Initial MCP Obsidian plugin setup
- Basic memory commands (/remember, /recall, /memories, /forget)
- Template system for different note types
- Integration with Obsidian community plugins
- GrepAI semantic search configuration