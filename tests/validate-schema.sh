#!/bin/bash

# Schema validation script for markdown files with YAML frontmatter
# Validates required fields in YAML frontmatter
# Exit code: 0 = valid, 1 = invalid

# Check if file argument provided
if [[ $# -eq 0 ]]; then
    echo "Error: No file provided"
    echo "Usage: $0 <markdown-file>"
    exit 1
fi

FILE="$1"

# Check if file exists
if [[ ! -f "$FILE" ]]; then
    echo "Error: File not found: $FILE"
    exit 1
fi

# Use Python to extract and validate YAML frontmatter
python3 - "$FILE" << 'PYTHON_SCRIPT'
import sys
import re
import yaml

# Required fields to validate
REQUIRED_FIELDS = [
    "agent_name",
    "agent_model",
    "session_id",
    "timestamp",
    "memory_type",
    "keywords",
    "embedding_model"
]

file_path = sys.argv[1]

try:
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Match YAML frontmatter between --- markers
    match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
    
    if not match:
        print("Error: No YAML frontmatter found (must start with ---)")
        sys.exit(1)
    
    frontmatter_text = match.group(1)
    
    # Parse YAML
    try:
        data = yaml.safe_load(frontmatter_text)
    except yaml.YAMLError as e:
        print(f"Error: Invalid YAML in frontmatter: {e}")
        sys.exit(1)
    
    if not isinstance(data, dict):
        print("Error: YAML frontmatter is not a valid dictionary")
        sys.exit(1)
    
    # Check for missing or empty required fields
    missing_fields = []
    for field in REQUIRED_FIELDS:
        if field not in data or data[field] is None or data[field] == '':
            missing_fields.append(field)
    
    if missing_fields:
        print(f"Error: Missing or empty required fields: {', '.join(missing_fields)}")
        sys.exit(1)
    
    print("Valid: All required fields present")
    sys.exit(0)
    
except FileNotFoundError:
    print(f"Error: File not found: {file_path}")
    sys.exit(1)
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)

PYTHON_SCRIPT
