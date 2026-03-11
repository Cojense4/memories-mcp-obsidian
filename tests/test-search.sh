#!/bin/bash

# Search functionality validation test suite
# Validates basic search capabilities across test files
# Exit code: 0 = pass, 1 = fail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TESTS_PASSED=0
TESTS_FAILED=0

echo "Search Functionality Tests"
echo "=========================="

# Test 1: Can search for text in valid schema
echo -n "Test 1: Search in valid schema file... "
if grep -q "TestAgent" "$SCRIPT_DIR/valid-schema.md" 2>/dev/null; then
    echo "PASS"
    ((TESTS_PASSED++))
else
    echo "FAIL"
    ((TESTS_FAILED++))
fi

# Test 2: Can search for YAML fields
echo -n "Test 2: Search for YAML fields... "
if grep -q "agent_name:" "$SCRIPT_DIR/valid-schema.md" 2>/dev/null; then
    echo "PASS"
    ((TESTS_PASSED++))
else
    echo "FAIL"
    ((TESTS_FAILED++))
fi

# Test 3: Search returns correct count
echo -n "Test 3: Search result count... "
COUNT=$(grep -c "^---" "$SCRIPT_DIR/valid-schema.md" 2>/dev/null || echo 0)
if [[ $COUNT -eq 2 ]]; then
    echo "PASS"
    ((TESTS_PASSED++))
else
    echo "FAIL (expected 2, got $COUNT)"
    ((TESTS_FAILED++))
fi

# Test 4: Case-sensitive search works
echo -n "Test 4: Case-sensitive search... "
if grep -q "claude-3-sonnet" "$SCRIPT_DIR/valid-schema.md" 2>/dev/null; then
    echo "PASS"
    ((TESTS_PASSED++))
else
    echo "FAIL"
    ((TESTS_FAILED++))
fi

# Test 5: Search in multiple files
echo -n "Test 5: Search across multiple files... "
MATCH_COUNT=$(grep -l "agent_name" "$SCRIPT_DIR"/*.md 2>/dev/null | wc -l)
if [[ $MATCH_COUNT -ge 2 ]]; then
    echo "PASS ($MATCH_COUNT files)"
    ((TESTS_PASSED++))
else
    echo "FAIL"
    ((TESTS_FAILED++))
fi

echo ""
echo "Search Tests: $TESTS_PASSED passed, $TESTS_FAILED failed"

if [[ $TESTS_FAILED -eq 0 ]]; then
    exit 0
else
    exit 1
fi
