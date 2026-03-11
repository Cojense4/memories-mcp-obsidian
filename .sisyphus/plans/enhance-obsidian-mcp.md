# Enhance MCP Obsidian Plugin with Agent Attribution

## TL;DR

> **Quick Summary**: Add agent attribution tracking and universal memory schema to the existing Obsidian MCP plugin, enabling both Claude Code and OpenCode to share memories with clear authorship tracking.
> 
> **Deliverables**:
> - Enhanced memory schema with agent attribution fields
> - Updated commands (/remember, /recall, /memories, /forget)
> - Updated templates (daily-note, project-init, research-note)
> - Integration with Obsidian community plugins
> - Tests after implementation
> 
> **Estimated Effort**: Medium
> **Parallel Execution**: YES - 3 waves
> **Critical Path**: Fix symlink → Update templates → Update commands → Test

---

## Context

### Original Request
User wants to enhance the existing MCP Obsidian plugin to create a fully functioning bridge between Obsidian and AI agents (Claude Code/OpenCode) for shared memory management with agent attribution.

### Interview Summary
**Key Discussions**:
- [Enhancement approach]: Enhance existing system, not replace
- [Agent tracking]: Track which agent made each memory change
- [Schema format]: Universal format readable by both machines and humans
- [Plugin leverage]: Use Local REST API, MCP Tools, Smart Connections, Templater, Git
- [Test strategy]: Add tests after implementation

**Research Findings**:
- [Current system]: Complete MCP-based memory system already exists
- [Commands]: /remember, /memories, /recall, /forget fully functional
- [Organization]: Structured folders (projects/, research/, dated-notes/)
- [Search]: Both MCP tools and GrepAI semantic search configured
- [Critical issue]: .memories/.memories symlink creates filesystem loop

### Metis Review
**Identified Gaps** (addressed):
- [Agent identity]: Need concrete agent identifiers, not hypotheticals
- [Update strategy]: No current update/edit command, only create/delete
- [Field naming]: Should `source` be renamed or kept alongside new fields?
- [Symlink loop]: Must fix .memories/.memories filesystem loop
- [Schema format]: Flat YAML vs nested for Obsidian Properties panel
- [Empty vault]: Almost zero existing data, backwards compatibility trivial

---

## Work Objectives

### Core Objective
Enhance the existing MCP Obsidian plugin to add agent attribution tracking while maintaining compatibility with both Claude Code and OpenCode agents.

### Concrete Deliverables
- Fixed filesystem loop (.memories/.memories symlink)
- Universal memory schema with agent attribution
- Updated command files (4 files in commands/)
- Updated template files (3 files in templates/)
- Updated skill files if needed (2 files in skills/)
- Shell-based test scripts for validation

### Definition of Done
- [ ] Symlink loop fixed - recursive operations no longer fail
- [ ] All memories include agent_id, agent_model, session_id in frontmatter
- [ ] All commands generate memories with new schema
- [ ] All templates include attribution fields
- [ ] GrepAI can index vault without errors
- [ ] Test scripts verify schema compliance

### Must Have
- Agent attribution via parameters (requestor provides agent info)
- Keep 'source' field AND add new attribution fields
- Full model identifier (e.g., anthropic/claude-opus-4-0)
- Simple agent name in metadata (e.g., claude-code)
- Session resume command as session_id (e.g., "ocx oc --continue ses_abc123")
- Enhanced metadata fields for indexing:
  - timestamp (ISO format)
  - context_window_size
  - temperature (if available)
  - tool_calls_made (list of tools used)
  - parent_memory_id (for conversation threads)
  - keywords (auto-extracted for search)
  - embedding_model (for GrepAI)
  - memory_type (conversation/fact/instruction/reference)
- Flat YAML schema (for Obsidian Properties panel)
- Integration with all Obsidian plugins:
  - MCP Tools (for external access)
  - Local REST API (for programmatic updates)
  - Git (for version tracking)
  - Smart Connections (for similarity search)
  - Templater (for template variables)
- GrepAI optimization with new metadata
- Backwards compatibility with existing structure
- Human-readable format in Obsidian
- Verifiable schema via automated tests

### Must NOT Have (Guardrails)
- No new MCP server implementation
- No folder structure changes
- No new Obsidian plugins
- No nested YAML (unless user overrides)
- No premature features (confidence scores, TTL)
- No Templater auto-population complexity
- No modification to .mcp.json or obsidian-mcp internals

---

## Verification Strategy (MANDATORY)

> **ZERO HUMAN INTERVENTION** — ALL verification is agent-executed. No exceptions.

### Test Decision
- **Infrastructure exists**: NO (shell scripts only)
- **Automated tests**: Tests-after
- **Framework**: Shell scripts with grep/yaml validation
- **Test approach**: Create test notes, validate frontmatter structure

### QA Policy
Every task MUST include agent-executed QA scenarios.
Evidence saved to `.sisyphus/evidence/task-{N}-{scenario-slug}.{ext}`.

- **Note creation**: Use MCP tools (obsidian_create) - verify frontmatter
- **Schema validation**: Use shell/python to parse YAML
- **Search verification**: Use grepai and MCP search tools
- **Symlink fix**: Use ls -la to verify no loops

---

## Execution Strategy

### Parallel Execution Waves

```
Wave 1 (Start Immediately — foundation fixes):
├── Task 1: Fix .memories/.memories symlink loop [quick]
└── Task 2: Create schema validation test script [quick]

Wave 2 (After Wave 1 — simultaneous updates):
├── Task 3: Update all 3 template files [quick]
├── Task 4: Update all 4 command files [unspecified-high]
└── Task 5: Update skill files if needed [quick]

Wave 3 (After Wave 2 — validation):
├── Task 6: Integration test - full memory lifecycle [unspecified-high]
└── Task 7: Add shell test suite [quick]

Wave 4 (After Wave 3 — optimization):
└── Task 8: Configure plugin integrations and GrepAI [unspecified-high]

Critical Path: Task 1 → Task 3/4 → Task 6 → Task 8
Parallel Speedup: ~50% faster than sequential
Max Concurrent: 3 (Wave 2)

### Dependency Matrix

- **Task 1**: — — 3, 4, 5, 6
- **Task 2**: — — 7
- **Task 3**: 1 — 6, 8
- **Task 4**: 1 — 6, 8
- **Task 5**: 1 — 6
- **Task 6**: 3, 4, 5 — 7, 8
- **Task 7**: 2, 6 — —
- **Task 8**: 3, 4, 6 — —

### Agent Dispatch Summary

- **Wave 1**: **2** — T1 → `quick`, T2 → `quick`
- **Wave 2**: **3** — T3 → `quick`, T4 → `unspecified-high`, T5 → `quick`
- **Wave 3**: **2** — T6 → `unspecified-high`, T7 → `quick`
- **Wave 4**: **1** — T8 → `unspecified-high`

---

## TODOs

- [x] 1. Fix .memories/.memories symlink loop

  **What to do**:
  - Navigate to .memories directory and check symlink: ls -la .memories/.memories
  - Remove the self-referential symlink: rm .memories/.memories
  - Verify recursive operations now work: find . -name '*.md' | head -5
  - Test GrepAI indexing doesn't error: grepai index status

  **Must NOT do**:
  - Do not create any new symlinks
  - Do not change other directory structures

  **Recommended Agent Profile**:
  > Simple filesystem fix requiring shell commands
  - **Category**: `quick`
    - Reason: Direct shell command execution, single file operation
  - **Skills**: []
    - No special skills needed for basic filesystem operations

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Task 2)
  - **Blocks**: Tasks 3, 4, 5, 6
  - **Blocked By**: None (can start immediately)

  **References**:
  **Error to fix**:
  - Current error: "rg: File system loop found: /Users/cjensen32/Documents/.memories/.memories"
  - This blocks all recursive search operations

  **Acceptance Criteria**:
  - [ ] ls -la .memories/.memories → "No such file or directory"
  - [ ] find . -name '*.md' → Completes without "File system loop" error
  - [ ] grepai index status → No filesystem errors reported

  **QA Scenarios**:

  ```
  Scenario: Verify symlink removed and operations work
    Tool: Bash
    Preconditions: In .memories directory
    Steps:
      1. ls -la .memories/.memories → capture output
      2. find . -type f -name '*.md' | wc -l → count files without error
      3. Run any recursive glob operation → verify no loop error
    Expected Result: No symlink exists, recursive operations complete
    Evidence: .sisyphus/evidence/task-1-symlink-fixed.txt

  Scenario: GrepAI can now index without errors
    Tool: Bash
    Preconditions: Symlink removed
    Steps:
      1. grepai index status → capture full output
      2. Check output for "loop" or "error" keywords
    Expected Result: Status shows healthy index, no loop errors
    Evidence: .sisyphus/evidence/task-1-grepai-status.txt
  ```

  **Commit**: YES
  - Message: `fix: remove .memories symlink loop`
  - Files: `.memories/.memories` (deleted)

- [x] 2. Create schema validation test script

  **What to do**:
  - Create tests/ directory for validation scripts
  - Write validate-schema.sh that parses YAML frontmatter
  - Script should check for required fields: agent_id, agent_model, session_id
  - Add Python YAML validation helper for robust parsing
  - Make script executable and testable

  **Must NOT do**:
  - Do not create complex test framework
  - Do not add external dependencies
  - Keep it simple shell + Python stdlib only

  **Recommended Agent Profile**:
  > Shell scripting and YAML validation logic
  - **Category**: `quick`
    - Reason: Simple script creation, well-defined requirements
  - **Skills**: []
    - Basic shell/Python scripting sufficient

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 1 (with Task 1)
  - **Blocks**: Task 7
  - **Blocked By**: None (can start immediately)

  **References**:
  **Schema to validate** (from Metis findings):
  - Current: tags, date, source, project (optional), topic (optional)
  - New: agent_id, agent_model, session_id, date, [DECISION NEEDED: flat vs nested]
  **Python YAML parsing**:
  - `python3 -c "import yaml; yaml.safe_load()"` pattern from Success Criteria

  **Acceptance Criteria**:
  - [ ] tests/validate-schema.sh exists and is executable
  - [ ] Script returns 0 for valid schema, 1 for invalid
  - [ ] Script outputs clear error messages for missing fields

  **QA Scenarios**:

  ```
  Scenario: Validate correct schema passes
    Tool: Bash
    Preconditions: Create test note with all required fields
    Steps:
      1. Create test-valid.md with agent_id, agent_model, session_id
      2. ./tests/validate-schema.sh test-valid.md
      3. echo $? → check exit code
    Expected Result: Exit code 0, no error output
    Evidence: .sisyphus/evidence/task-2-valid-schema.txt

  Scenario: Missing fields are detected
    Tool: Bash
    Preconditions: Create test note missing agent_id
    Steps:
      1. Create test-invalid.md without agent_id field
      2. ./tests/validate-schema.sh test-invalid.md
      3. Capture error output
    Expected Result: Exit code 1, error mentions "missing agent_id"
    Evidence: .sisyphus/evidence/task-2-invalid-schema.txt
  ```

  **Commit**: YES (groups with 1)
  - Message: `test: add schema validation script`
  - Files: `tests/validate-schema.sh`

- [x] 3. Update all 3 template files with attribution schema

  **What to do**:
  - Update templates/daily-note.md with full metadata schema
  - Update templates/project-init.md with full metadata schema
  - Update templates/research-note.md with full metadata schema
  - Keep existing 'source' field, add new attribution fields
  - Add ALL metadata fields for enhanced indexing:
    - source: claude-code (keep existing)
    - agent_name: Simple name (e.g., "claude-code")
    - agent_model: Full identifier (e.g., "anthropic/claude-opus-4-0")
    - session_id: Resume command (e.g., "ocx oc --continue ses_abc123")
    - timestamp: {{date}} {{time}} (ISO format via Templater)
    - context_window_size: (parameter from agent)
    - temperature: (if provided)
    - tool_calls_made: [] (to be filled by commands)
    - parent_memory_id: (for conversation threads)
    - keywords: [] (for search optimization)
    - embedding_model: "nomic-embed-text" (for GrepAI)
    - memory_type: (conversation/fact/instruction/reference)
  - Ensure Templater variables work for dynamic fields

  **Must NOT do**:
  - Do not use nested YAML structure
  - Do not remove existing fields (keep backwards compatibility)
  - Do not break existing template variables

  **Recommended Agent Profile**:
  > Markdown template updates with YAML frontmatter
  - **Category**: `quick`
    - Reason: Simple file edits, clear requirements
  - **Skills**: []
    - Basic markdown/YAML editing

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 4, 5)
  - **Blocks**: Task 6
  - **Blocked By**: Task 1 (symlink fix)

  **References**:
  **Current template structure**:
  - `templates/daily-note.md:1-6` - Current frontmatter format
  - `templates/project-init.md:1-6` - Similar structure
  - `templates/research-note.md:1-7` - Includes 'topic' field
  **New unified schema** (user decisions):
  - Keep 'source' field for backwards compatibility
  - agent_name: Simple identifier
  - agent_model: Full model path
  - session_id: Terminal resume command
  - Enhanced metadata for indexing

  **Acceptance Criteria**:
  - [ ] All 3 templates keep 'source' field
  - [ ] All 3 templates contain agent_name field
  - [ ] All 3 templates contain agent_model field
  - [ ] All 3 templates contain session_id field
  - [ ] All 3 templates contain timestamp with Templater variable
  - [ ] All 3 templates contain context_window_size field
  - [ ] All 3 templates contain memory_type field
  - [ ] All 3 templates contain keywords array field
  - [ ] All 3 templates contain embedding_model field
  - [ ] YAML remains flat (no nested structures)
  - [ ] Templates work with Templater plugin variables

  **QA Scenarios**:

  ```
  Scenario: Templates contain new fields
    Tool: Bash (grep)
    Preconditions: Templates updated
    Steps:
      1. grep -l "agent_id:" templates/*.md | wc -l
      2. grep -l "agent_model:" templates/*.md | wc -l
      3. grep -l "session_id:" templates/*.md | wc -l
    Expected Result: Each grep returns "3" (all templates have fields)
    Evidence: .sisyphus/evidence/task-3-template-fields.txt

  Scenario: YAML structure is valid and flat
    Tool: Bash (python)
    Preconditions: Templates updated
    Steps:
      1. For each template, extract frontmatter between --- markers
      2. python3 -c "import yaml; d=yaml.safe_load(fm); print('flat' if all(not isinstance(v,dict) for v in d.values()) else 'nested')"
    Expected Result: Returns "flat" for all templates
    Evidence: .sisyphus/evidence/task-3-yaml-flat.txt
  ```

  **Commit**: NO (groups with Wave 2)

- [x] 4. Update all 4 command files with attribution logic

  **What to do**:
  - Update commands/remember.md to accept agent parameters:
    - --agent-name (required): Simple agent identifier
    - --agent-model (required): Full model path
    - --session-id (required): Resume command
    - --context-window (optional): Context size
    - --temperature (optional): Temperature setting
  - Update commands/recall.md to display all attribution metadata
  - Update commands/memories.md to show agent info in listings
  - Update commands/forget.md (if it modifies notes)
  - Add parameter validation and helpful error messages
  - Integrate with Obsidian plugins:
    - Use Local REST API for programmatic access
    - Trigger Git commits after memory operations
    - Update Smart Connections index after new memories
  - Ensure both Claude Code and OpenCode can pass parameters

  **Must NOT do**:
  - Do not break existing command functionality
  - Do not hardcode "claude-code" anymore
  - Do not assume specific agent formats

  **Recommended Agent Profile**:
  > Complex command logic updates requiring careful editing
  - **Category**: `unspecified-high`
    - Reason: Multiple files, logic changes, agent detection complexity
  - **Skills**: []
    - Command structure understanding needed

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 3, 5)
  - **Blocks**: Task 6
  - **Blocked By**: Task 1 (symlink fix)

  **References**:
  **Current command implementation**:
  - `commands/remember.md:14-19` - Current frontmatter generation
  - `commands/remember.md:30` - Hardcoded "source: claude-code"
  - `commands/recall.md` - Search implementation
  - `commands/memories.md` - Listing logic
  **Parameter-based agent detection** (user decision):
  - Commands will require agent info as parameters
  - Example: /remember --agent-name "claude-code" --agent-model "anthropic/claude-opus-4-0"
  - Session ID format: "ocx oc --continue ses_abc123" or "claude -c ses_xyz"
  **Obsidian plugin integration**:
  - Local REST API: For programmatic updates
  - Git: Auto-commit after memory operations
  - Smart Connections: Update index after new memories

  **Acceptance Criteria**:
  - [ ] /remember accepts required parameters: --agent-name, --agent-model, --session-id
  - [ ] /remember validates parameters and shows helpful errors if missing
  - [ ] /remember creates notes with all metadata fields populated
  - [ ] Agent fields use parameter values, NOT hardcoded
  - [ ] /recall displays full attribution metadata
  - [ ] /memories shows agent name and model in listings
  - [ ] Commands trigger Git commit after operations
  - [ ] Commands update Smart Connections index
  - [ ] Commands work with both Claude Code and OpenCode

  **QA Scenarios**:

  ```
  Scenario: /remember with parameters creates attributed note
    Tool: interactive_bash (tmux)
    Preconditions: In Claude Code or OpenCode session
    Steps:
      1. tmux new-session -d -s test-remember
      2. Send: /remember "Test memory" --agent-name "claude-code" --agent-model "anthropic/claude-opus-4-0" --session-id "claude -c ses_abc123" --context-window 200000
      3. Find created note and extract frontmatter
      4. Verify all attribution fields are populated from parameters
    Expected Result: Note contains all parameter values in metadata
    Evidence: .sisyphus/evidence/task-4-remember-parameters.md

  Scenario: Missing parameters show helpful error
    Tool: interactive_bash (tmux)
    Preconditions: Command updated with validation
    Steps:
      1. tmux new-session -d -s test-validation
      2. Send: /remember "Test" (without required parameters)
      3. Capture error message
    Expected Result: Clear error listing required parameters
    Evidence: .sisyphus/evidence/task-4-parameter-validation.txt
  ```

  **Commit**: YES (groups with Wave 2)
  - Message: `feat: add dynamic agent attribution to memory commands`
  - Files: `commands/*.md`

- [x] 5. Update skill files if they reference schema fields

  **What to do**:
  - Check skills/memory-retrieval/SKILL.md for schema references
  - Check skills/memory-suggestion/SKILL.md for schema references
  - Update any references to old 'source' field
  - Ensure skills work with new attribution fields
  - Test skill functionality still works

  **Must NOT do**:
  - Do not change skill core functionality
  - Do not add new skills
  - Do not modify skill selection logic

  **Recommended Agent Profile**:
  > Quick review and minor updates to skill definitions
  - **Category**: `quick`
    - Reason: Simple file review, minimal changes expected
  - **Skills**: []
    - Basic markdown editing

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 2 (with Tasks 3, 4)
  - **Blocks**: Task 6
  - **Blocked By**: Task 1 (symlink fix)

  **References**:
  **Current skill files**:
  - `skills/memory-retrieval/SKILL.md` - Memory search skill
  - `skills/memory-suggestion/SKILL.md` - Memory recommendation skill
  **Check for**:
  - References to 'source' field
  - Assumptions about frontmatter structure
  - Search/filter logic that might need updating

  **Acceptance Criteria**:
  - [ ] Skills reference new schema fields correctly
  - [ ] No references to old 'source: claude-code' remain
  - [ ] Skills activate properly with new schema

  **QA Scenarios**:

  ```
  Scenario: Skills don't reference old schema
    Tool: Bash (grep)
    Preconditions: Skills updated
    Steps:
      1. grep -r "source: claude-code" skills/
      2. grep -r "source:" skills/ | grep -v "agent"
    Expected Result: No matches for hardcoded source field
    Evidence: .sisyphus/evidence/task-5-no-old-schema.txt

  Scenario: Memory retrieval works with new schema
    Tool: Bash
    Preconditions: Test note exists with new schema
    Steps:
      1. Create test note with agent attribution
      2. Trigger memory-retrieval skill
      3. Verify it finds and returns the test note
    Expected Result: Skill works with new schema fields
    Evidence: .sisyphus/evidence/task-5-retrieval-works.txt
  ```

  **Commit**: NO (groups with Wave 2)

- [x] 6. Integration test - full memory lifecycle

  **What to do**:
  - Create comprehensive test of entire memory system
  - Test /remember with new attribution
  - Test /recall finds memories with agent info
  - Test /memories lists with attribution
  - Test GrepAI search works with new schema
  - Verify Obsidian Properties panel displays fields

  **Must NOT do**:
  - Do not create unit tests for individual functions
  - Do not test edge cases exhaustively (save for test suite)
  - Focus on happy path validation

  **Recommended Agent Profile**:
  > End-to-end testing requiring multiple tools and verification
  - **Category**: `unspecified-high`
    - Reason: Complex integration testing across multiple components
  - **Skills**: [`dev-browser`]
    - `dev-browser`: To verify Obsidian UI displays properties correctly

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 3 (with Task 7)
  - **Blocks**: Task 7
  - **Blocked By**: Tasks 3, 4, 5 (all updates complete)

  **References**:
  **Test flow**:
  - Commands to test: /remember, /recall, /memories
  - MCP tools: obsidian_create, obsidian_search, obsidian_read
  - Verification: Check frontmatter, search results, UI display
  **Expected behavior**:
  - New notes have agent_id, agent_model, session_id
  - Search returns notes with attribution visible
  - Obsidian shows fields in Properties panel

  **Acceptance Criteria**:
  - [ ] /remember creates note with all attribution fields
  - [ ] /recall returns memories showing agent info
  - [ ] /memories lists memories with agent attribution
  - [ ] GrepAI search finds notes by content
  - [ ] Obsidian Properties panel shows new fields

  **QA Scenarios**:

  ```
  Scenario: Full memory lifecycle works
    Tool: interactive_bash (tmux)
    Preconditions: Clean test environment
    Steps:
      1. tmux new-session -d -s test-integration
      2. /remember "Integration test memory"
      3. /recall "integration test"
      4. /memories --limit 5
      5. Capture all outputs showing attribution
    Expected Result: All commands show agent attribution
    Evidence: .sisyphus/evidence/task-6-lifecycle.txt

  Scenario: Obsidian UI displays properties
    Tool: dev-browser (playwright)
    Preconditions: Note created with new schema
    Steps:
      1. Open Obsidian to test note
      2. Switch to reading mode
      3. Open Properties panel
      4. Screenshot showing agent fields
    Expected Result: Properties panel shows agent_id, agent_model, session_id
    Evidence: .sisyphus/evidence/task-6-obsidian-properties.png
  ```

  **Commit**: NO (part of test wave)

- [x] 7. Add shell test suite for ongoing validation

  **What to do**:
  - Create tests/run-all-tests.sh main test runner
  - Add tests/test-schema.sh for schema validation
  - Add tests/test-commands.sh for command testing
  - Add tests/test-search.sh for search validation
  - Make all scripts executable and documented
  - Include in project documentation

  **Must NOT do**:
  - Do not use external test frameworks
  - Do not create complex test infrastructure
  - Keep it simple and maintainable

  **Recommended Agent Profile**:
  > Shell scripting for test automation
  - **Category**: `quick`
    - Reason: Straightforward shell script creation
  - **Skills**: []
    - Basic shell scripting

  **Parallelization**:
  - **Can Run In Parallel**: YES
  - **Parallel Group**: Wave 3 (with Task 6)
  - **Blocks**: None (end task)
  - **Blocked By**: Task 2 (validation script), Task 6 (proven patterns)

  **References**:
  **Test patterns from**:
  - Task 2 validation script structure
  - Task 6 integration test patterns
  - Success Criteria section commands
  **Test categories**:
  - Schema validation (YAML structure)
  - Command functionality (CRUD operations)
  - Search capabilities (GrepAI, MCP search)

  **Acceptance Criteria**:
  - [ ] tests/run-all-tests.sh exists and runs all tests
  - [ ] Individual test scripts for schema, commands, search
  - [ ] All scripts are executable (chmod +x)
  - [ ] Scripts return proper exit codes (0=pass, 1=fail)
  - [ ] Basic documentation in script headers

  **QA Scenarios**:

  ```
  Scenario: Test suite runs successfully
    Tool: Bash
    Preconditions: All test scripts created
    Steps:
      1. cd tests/
      2. ./run-all-tests.sh
      3. echo $? (check exit code)
      4. Review output for any failures
    Expected Result: All tests pass, exit code 0
    Evidence: .sisyphus/evidence/task-7-test-suite-pass.txt

  Scenario: Test detects schema violations
    Tool: Bash
    Preconditions: Create note with missing agent_id
    Steps:
      1. Create bad-note.md without required fields
      2. ./tests/test-schema.sh bad-note.md
      3. Verify it fails with clear error
    Expected Result: Test fails, reports missing field
    Evidence: .sisyphus/evidence/task-7-schema-detection.txt
  ```

  **Commit**: YES
  - Message: `test: add shell test suite for memory schema validation`
  - Files: `tests/*.sh`

- [x] 8. Configure plugin integrations and GrepAI optimization

  **What to do**:
  - Configure Git auto-commit for memory operations:
    - Set up post-operation hooks in commands
    - Configure meaningful commit messages with metadata
  - Optimize GrepAI for new schema:
    - Update .grepai/config.yaml with metadata field indexing
    - Add custom extractors for keywords and memory_type
    - Test semantic search with new fields
  - Configure Smart Connections:
    - Ensure it indexes new metadata fields
    - Test similarity search with agent attribution
  - Set up Local REST API integration:
    - Document API endpoints for external agent access
    - Create example scripts for programmatic memory management
  - Configure MCP Tools for cross-agent compatibility

  **Must NOT do**:
  - Do not modify core plugin configurations
  - Do not break existing integrations
  - Do not add new plugins

  **Recommended Agent Profile**:
  > Configuration and integration optimization
  - **Category**: `unspecified-high`
    - Reason: Multiple plugin configurations, testing required
  - **Skills**: []
    - Plugin configuration expertise

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Parallel Group**: Wave 4 (standalone)
  - **Blocks**: None
  - **Blocked By**: Tasks 3, 4, 6 (schema and commands must be complete)

  **References**:
  **Plugin locations**:
  - `.grepai/config.yaml` - Semantic search configuration
  - `.obsidian/plugins/*/data.json` - Plugin configurations
  - `.obsidian/community-plugins.json` - Installed plugins list
  **Integration points**:
  - Git hooks in command files
  - GrepAI metadata extractors
  - Smart Connections indexing
  - Local REST API endpoints

  **Acceptance Criteria**:
  - [ ] Git commits automatically after memory operations
  - [ ] GrepAI indexes all metadata fields
  - [ ] Smart Connections finds similar memories by agent
  - [ ] Local REST API can create/read memories programmatically
  - [ ] MCP Tools work across Claude Code and OpenCode

  **QA Scenarios**:

  ```
  Scenario: Git auto-commits after memory creation
    Tool: Bash
    Preconditions: Git configured, memory created
    Steps:
      1. /remember "Test auto-commit" --agent-name "test"
      2. git log -1 --oneline
      3. Verify commit message contains metadata
    Expected Result: Auto-commit with descriptive message
    Evidence: .sisyphus/evidence/task-8-git-autocommit.txt

  Scenario: GrepAI searches by new metadata
    Tool: Bash (grepai)
    Preconditions: Memories with different agents exist
    Steps:
      1. Create memories from different agents
      2. grepai search --query "agent_name:claude-code"
      3. Verify only Claude memories returned
    Expected Result: Filtered results by metadata
    Evidence: .sisyphus/evidence/task-8-grepai-metadata.txt
  ```

  **Commit**: YES
  - Message: `feat: configure plugin integrations for enhanced metadata`
  - Files: `.grepai/config.yaml, commands/*.md updates`

---

## Final Verification Wave (MANDATORY — after ALL implementation tasks)

> 4 review agents run in PARALLEL. ALL must APPROVE. Rejection → fix → re-run.

- [ ] F1. **Plan Compliance Audit** — `oracle`
  Read the plan end-to-end. For each "Must Have": verify implementation exists. Check all 4 commands include attribution fields. Verify all 3 templates have schema. Confirm symlink is fixed. Check evidence files exist in .sisyphus/evidence/.
  Output: `Must Have [24/24] | Must NOT Have [7/7] | Tasks [8/8] | VERDICT: APPROVE/REJECT`

- [ ] F2. **Code Quality Review** — `unspecified-high`
  Validate all YAML frontmatter in templates and command-generated notes. Run schema validation script. Check for syntax errors in shell scripts. Verify no broken references in skills/commands.
  Output: `YAML Valid [N/N] | Scripts [PASS/FAIL] | References [N clean/N broken] | VERDICT`

- [ ] F3. **Real Manual QA** — `unspecified-high`
  Execute full memory lifecycle: /remember → /recall → /memories → /forget. Test with different agent contexts. Verify GrepAI search works. Check Obsidian Properties panel shows fields correctly.
  Output: `Commands [4/4 pass] | Search [PASS/FAIL] | Properties [VISIBLE/HIDDEN] | VERDICT`

- [ ] F4. **Scope Fidelity Check** — `deep`
  Verify no new MCP server created. Confirm folder structure unchanged. Check no new plugins added. Ensure schema is flat YAML. Verify no premature features added.
  Output: `Scope compliance [N/N] | No feature creep | VERDICT`

---

## Commit Strategy

- **Wave 1**: `fix: remove .memories symlink loop` — .memories
- **Wave 2**: `feat: add agent attribution to memory schema` — commands/, templates/, skills/
- **Wave 3**: `test: add schema validation tests` — tests/
- **Wave 4**: `feat: configure plugin integrations for enhanced metadata` — .grepai/config.yaml, commands/

---

## Success Criteria

### Verification Commands
```bash
# Symlink loop fixed
ls -la .memories/.memories  # Expected: No such file (removed)

# Schema includes attribution
grep -E "(agent_id|agent_model|session_id):" projects/test-note.md  # Expected: 3 matches

# Templates updated
grep "agent_id:" templates/*.md  # Expected: 3 files match

# Commands work
/remember "Test memory"  # Creates note with attribution

# YAML valid
python3 -c "import yaml; yaml.safe_load(open('test-note.md').read().split('---')[1])"  # No error

# Search works
grepai index status  # Expected: No filesystem loop errors
```

### Final Checklist
- [ ] All new memories include full attribution metadata
- [ ] Obsidian Properties panel shows all metadata fields
- [ ] No filesystem loops
- [ ] Tests verify schema automatically
- [ ] Git auto-commits after memory operations
- [ ] GrepAI indexes and searches by metadata
- [ ] Smart Connections finds similar memories
- [ ] Local REST API provides programmatic access
- [ ] Both Claude Code and OpenCode can create memories