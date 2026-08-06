#!/bin/bash

# Test script for Documize
# Runs both Go and Ember tests

set -e

echo "=========================================="
echo "Running Documize Test Suite"
echo "=========================================="

# Track overall status
OVERALL_STATUS=0

# Function to run a test stage and track status
run_stage() {
    local stage_name="$1"
    echo ""
    echo "----------------------------------------"
    echo "Running: $stage_name"
    echo "----------------------------------------"
    
    if "$2"; then
        echo "✅ $stage_name passed"
        return 0
    else
        echo "❌ $stage_name failed"
        OVERALL_STATUS=1
        return 1
    fi
}

# Stage 1: Go tests
echo ""
echo "Running Go tests..."
run_stage "Go unit tests" "go test ./..."

# Stage 2: Go build verification
echo ""
echo "Verifying Go build..."
run_stage "Go build check" "go build -v ./edition/community.go 2>&1 | head -20"

# Stage 3: Ember tests (if Node.js is available)
if command -v npm &> /dev/null; then
    echo ""
    echo "Node.js detected, running Ember tests..."
    
    cd gui
    
    # Install dependencies if needed
    if [ ! -d "node_modules" ]; then
        echo "Installing npm dependencies..."
        npm install
    fi
    
    # Run Ember tests
    run_stage "Ember tests" "npm test"
    
    cd ..
else
    echo ""
    echo "⚠️  Node.js not found, skipping Ember tests"
    echo "   Ember tests require Node.js and npm"
fi

# Final summary
echo ""
echo "=========================================="
if [ $OVERALL_STATUS -eq 0 ]; then
    echo "✅ All tests passed!"
    echo "=========================================="
    exit 0
else
    echo "❌ Some tests failed"
    echo "=========================================="
    exit 1
fi
