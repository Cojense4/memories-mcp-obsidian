#!/bin/bash

# Schema validation test suite
# Validates YAML frontmatter in markdown files
# Exit code: 0 = pass, 1 = fail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALIDATE_SCRIPT="$SCRIPT_DIR/validate-schema.sh"

# Check if validate-schema.sh exists
if [[ ! -f "$VALIDATE_SCRIPT" ]]; then
    echo "Error: validate-schema.sh not found at $VALIDATE_SCRIPT"
    exit 1
fi

TESTS_PASSED=0
TESTS_FAILED=0

echo "Schema Validation Tests"
echo "======================"

# Test 1: Valid schema should pass
echo -n "Test 1: Valid schema file... "
if bash "$VALIDATE_SCRIPT" "$SCRIPT_DIR/valid-schema.md" > /dev/null 2>&1; then
    echo "PASS"
    ((TESTS_PASSED++))
else
    echo "FAIL"
    ((TESTS_FAILED++))
fi

# Test 2: Invalid schema should fail
echo -n "Test 2: Invalid schema file... "
if ! bash "$VALIDATE_SCRIPT" "$SCRIPT_DIR/invalid-schema.md" > /dev/null 2>&1; then
    echo "PASS"
    ((TESTS_PASSED++))
else
    echo "FAIL"
    ((TESTS_FAILED++))
fi

# Test 3: Missing frontmatter should fail
echo -n "Test 3: Missing frontmatter... "
if ! bash "$VALIDATE_SCRIPT" "$SCRIPT_DIR/no-frontmatter.md" > /dev/null 2>&1; then
    echo "PASS"
    ((TESTS_PASSED++))
else
    echo "FAIL"
    ((TESTS_FAILED++))
fi

# Test 4: Non-existent file should fail
echo -n "Test 4: Non-existent file... "
if ! bash "$VALIDATE_SCRIPT" "$SCRIPT_DIR/nonexistent.md" > /dev/null 2>&1; then
    echo "PASS"
    ((TESTS_PASSED++))
else
    echo "FAIL"
    ((TESTS_FAILED++))
fi

echo ""
echo "Schema Tests: $TESTS_PASSED passed, $TESTS_FAILED failed"

if [[ $TESTS_FAILED -eq 0 ]]; then
    exit 0
else
    exit 1
fi
