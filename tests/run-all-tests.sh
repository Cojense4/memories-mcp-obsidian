#!/bin/bash

# Main test runner for Obsidian MCP test suite
# Executes all individual test scripts and reports results
# Exit code: 0 = all pass, 1 = any fail

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTS_PASSED=0
TESTS_FAILED=0

echo "=========================================="
echo "Obsidian MCP Test Suite"
echo "=========================================="
echo ""

# Test 1: Schema validation
echo "[1/3] Running schema tests..."
if bash "$SCRIPT_DIR/test-schema.sh"; then
    echo "✓ Schema tests passed"
    ((TESTS_PASSED++))
else
    echo "✗ Schema tests failed"
    ((TESTS_FAILED++))
fi
echo ""

# Test 2: Command structure validation
echo "[2/3] Running command tests..."
if bash "$SCRIPT_DIR/test-commands.sh"; then
    echo "✓ Command tests passed"
    ((TESTS_PASSED++))
else
    echo "✗ Command tests failed"
    ((TESTS_FAILED++))
fi
echo ""

# Test 3: Search functionality
echo "[3/3] Running search tests..."
if bash "$SCRIPT_DIR/test-search.sh"; then
    echo "✓ Search tests passed"
    ((TESTS_PASSED++))
else
    echo "✗ Search tests failed"
    ((TESTS_FAILED++))
fi
echo ""

# Summary
echo "=========================================="
echo "Test Results: $TESTS_PASSED passed, $TESTS_FAILED failed"
echo "=========================================="

if [[ $TESTS_FAILED -eq 0 ]]; then
    exit 0
else
    exit 1
fi
