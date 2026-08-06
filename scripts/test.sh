#!/bin/bash

# Test script for Documize
# Runs both Go and Ember tests
# Each stage runs independently and reports its status

echo "=========================================="
echo "Running Documize Test Suite"
echo "=========================================="

# Track overall status
OVERALL_STATUS=0

# Function to run a test stage and track status
run_stage() {
    local stage_name="$1"
    local command="$2"
    
    echo ""
    echo "----------------------------------------"
    echo "Running: $stage_name"
    echo "----------------------------------------"
    
    if eval "$command"; then
        echo "[PASS] $stage_name passed"
        return 0
    else
        local exit_code=$?
        echo "[FAIL] $stage_name failed (exit code: $exit_code)"
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
run_stage "Go build check" "go build -o /tmp/documize-test ./edition/community.go"

# Stage 3: Ember tests (if Node.js is available)
if command -v npm &> /dev/null; then
    echo ""
    echo "Node.js detected, running Ember tests..."
    
    cd gui
    
    # Install dependencies if needed
    if [ ! -d "node_modules" ]; then
        echo "Installing npm dependencies..."
        npm install || {
            echo "[WARN] npm install failed, trying to continue with existing node_modules"
            cd ..
            run_stage "Ember tests" "cd gui && npm test"
            return
        }
    fi
    
    # Run Ember tests
    run_stage "Ember tests" "npm test"
    
    cd ..
else
    echo ""
    echo "[SKIP] Node.js not found, skipping Ember tests"
    echo "      Ember tests require Node.js and npm"
fi

# Final summary
echo ""
echo "=========================================="
if [ $OVERALL_STATUS -eq 0 ]; then
    echo "[SUCCESS] All tests passed!"
    echo "=========================================="
    exit 0
else
    echo "[FAILURE] Some tests failed"
    echo "=========================================="
    exit 1
fi
