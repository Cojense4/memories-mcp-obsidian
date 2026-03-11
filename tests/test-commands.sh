#!/bin/bash

# Command structure validation test suite
# Validates that command files have proper structure
# Exit code: 0 = pass, 1 = fail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$(dirname "$SCRIPT_DIR")/commands"

TESTS_PASSED=0
TESTS_FAILED=0

echo "Command Structure Tests"
echo "======================"

# Check if commands directory exists
if [[ ! -d "$COMMANDS_DIR" ]]; then
    echo "Error: commands directory not found at $COMMANDS_DIR"
    exit 1
fi

# Test 1: Commands directory exists
echo -n "Test 1: Commands directory exists... "
if [[ -d "$COMMANDS_DIR" ]]; then
    echo "PASS"
    ((TESTS_PASSED++))
else
    echo "FAIL"
    ((TESTS_FAILED++))
fi

# Test 2: At least one command file exists
echo -n "Test 2: Command files exist... "
COMMAND_COUNT=$(find "$COMMANDS_DIR" -name "*.md" -type f 2>/dev/null | wc -l)
if [[ $COMMAND_COUNT -gt 0 ]]; then
    echo "PASS ($COMMAND_COUNT files)"
    ((TESTS_PASSED++))
else
    echo "FAIL"
    ((TESTS_FAILED++))
fi

# Test 3: All command files are readable
echo -n "Test 3: All command files readable... "
UNREADABLE=0
while IFS= read -r file; do
    if [[ ! -r "$file" ]]; then
        ((UNREADABLE++))
    fi
done < <(find "$COMMANDS_DIR" -name "*.md" -type f 2>/dev/null)

if [[ $UNREADABLE -eq 0 ]]; then
    echo "PASS"
    ((TESTS_PASSED++))
else
    echo "FAIL ($UNREADABLE unreadable)"
    ((TESTS_FAILED++))
fi

# Test 4: Command files have content
echo -n "Test 4: Command files have content... "
EMPTY_FILES=0
while IFS= read -r file; do
    if [[ ! -s "$file" ]]; then
        ((EMPTY_FILES++))
    fi
done < <(find "$COMMANDS_DIR" -name "*.md" -type f 2>/dev/null)

if [[ $EMPTY_FILES -eq 0 ]]; then
    echo "PASS"
    ((TESTS_PASSED++))
else
    echo "FAIL ($EMPTY_FILES empty)"
    ((TESTS_FAILED++))
fi

echo ""
echo "Command Tests: $TESTS_PASSED passed, $TESTS_FAILED failed"

if [[ $TESTS_FAILED -eq 0 ]]; then
    exit 0
else
    exit 1
fi
