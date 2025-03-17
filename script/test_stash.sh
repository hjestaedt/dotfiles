#!/usr/bin/env bash
#
# test_stash.sh - Comprehensive test suite for the stash utility
#
# This script runs various tests against the stash utility to ensure
# it functions correctly. It creates temporary files, stashes them,
# and verifies all operations work as expected.
#
# Usage: ./test_stash.sh [path/to/stash]
#
# Note: This will create temporary files in /tmp/stash_test_*

set -euo pipefail

# Configuration
readonly TEST_DIR="/tmp/stash_test_$$"
readonly STASH_HOME="${TEST_DIR}/home"
readonly STASH_VAR="${STASH_HOME}/var"
readonly STASH_STORAGE="${STASH_VAR}/stash"
readonly ORIGINAL_HOME="$HOME"
readonly GREEN="\033[0;32m"
readonly RED="\033[0;31m"
readonly YELLOW="\033[0;33m"
readonly RESET="\033[0m"

# Find the stash script to test
if [[ $# -gt 0 ]]; then
    STASH_CMD="$1"
else
    # Try to find it in common locations
    if command -v stash > /dev/null 2>&1; then
        STASH_CMD="stash"
    elif [[ -x "$HOME/bin/stash" ]]; then
        STASH_CMD="$HOME/bin/stash"
    elif [[ -x "./stash" ]]; then
        STASH_CMD="./stash"
    else
        echo -e "${RED}Error: Could not find stash script. Please provide path as an argument.${RESET}"
        exit 1
    fi
fi

# Count of tests passed, failed, and skipped
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0
TESTS_TOTAL=0

# Cleanup function to remove test files
cleanup() {
    echo "Cleaning up test environment..."
    HOME="$ORIGINAL_HOME"
    rm -rf "$TEST_DIR"
    echo "Done."
}

# Log a message with timestamp
log() {
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $*"
}

# Function to mark a test as passed
pass() {
    local test_name="$1"
    echo -e "${GREEN}✓ PASS:${RESET} $test_name"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

# Function to mark a test as failed
fail() {
    local test_name="$1"
    local message="${2:-No details provided}"
    echo -e "${RED}✗ FAIL:${RESET} $test_name - $message"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

# Function to mark a test as skipped
skip() {
    local test_name="$1"
    local reason="${2:-No reason provided}"
    echo -e "${YELLOW}⚠ SKIP:${RESET} $test_name - $reason"
    TESTS_SKIPPED=$((TESTS_SKIPPED + 1))
}

# Function to run a test
run_test() {
    local test_name="$1"
    local test_func="$2"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    echo "======================================================================"
    echo "Running test: $test_name"
    
    # Create a completely new test environment for each test
    rm -rf "$TEST_DIR"
    mkdir -p "$STASH_VAR"
    mkdir -p "${TEST_DIR}/files/subdir1/subdir2"
    echo "Test file 1 content" > "${TEST_DIR}/files/file1.txt"
    echo "Test file 2 content" > "${TEST_DIR}/files/file2.txt"
    echo "Test file 3 content" > "${TEST_DIR}/files/subdir1/file3.txt"
    echo "Test file 4 content" > "${TEST_DIR}/files/subdir1/subdir2/file4.txt"
    
    # Set HOME to our test home
    mkdir -p "$STASH_HOME"
    export HOME="$STASH_HOME"
    
    # Make sure no stashes exist
    if [[ -d "$STASH_STORAGE" ]]; then
        rm -rf "${STASH_STORAGE}/stash-"*
    fi
    
    # Debug: Check stash count before test
    local initial_count
    initial_count=$(count_stashes)
    echo "Debug: Initial stash count before test: $initial_count"
    
    # Run the test function
    if $test_func; then
        pass "$test_name"
        return 0
    else
        fail "$test_name"
        return 1
    fi
}

# Function to create a clean test environment
clean_test_env() {
    # Remove existing test directory if it exists
    rm -rf "$TEST_DIR"
    
    # Create test directory structure
    mkdir -p "$STASH_VAR"
    
    # Create some test files and directories
    mkdir -p "${TEST_DIR}/files/subdir1/subdir2"
    echo "Test file 1 content" > "${TEST_DIR}/files/file1.txt"
    echo "Test file 2 content" > "${TEST_DIR}/files/file2.txt"
    echo "Test file 3 content" > "${TEST_DIR}/files/subdir1/file3.txt"
    echo "Test file 4 content" > "${TEST_DIR}/files/subdir1/subdir2/file4.txt"
    
    # Set HOME to our test home
    mkdir -p "$STASH_HOME"
    export HOME="$STASH_HOME"
}

# Function to check if a file exists
assert_file_exists() {
    local file="$1"
    if [[ -f "$file" ]]; then
        return 0
    else
        echo "File does not exist: $file"
        return 1
    fi
}

# Function to check if a directory exists
assert_dir_exists() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        return 0
    else
        echo "Directory does not exist: $dir"
        return 1
    fi
}

# Function to check if a file or directory does not exist
assert_not_exists() {
    local path="$1"
    if [[ ! -e "$path" ]]; then
        return 0
    else
        echo "Path exists when it should not: $path"
        return 1
    fi
}

# Function to check if a file contains specific content
assert_file_contains() {
    local file="$1"
    local pattern="$2"
    if grep -q "$pattern" "$file"; then
        return 0
    else
        echo "File does not contain expected pattern: $pattern"
        echo "File content:"
        cat "$file"
        return 1
    fi
}

# Function to count the number of stash entries
count_stashes() {
    if [[ -d "$STASH_STORAGE" ]]; then
        local count
        count=$(find "$STASH_STORAGE" -maxdepth 1 -name "stash-*" -type d | wc -l)
        echo "$count"
    else
        echo "0"
    fi
}

# Function to extract the ID of the first stash
get_first_stash_id() {
    if [[ -d "$STASH_STORAGE" ]]; then
        local stash_id
        stash_id=$(find "$STASH_STORAGE" -maxdepth 1 -name "stash-*" -type d | sort | head -1)
        if [[ -n "$stash_id" ]]; then
            basename "$stash_id"
            return 0
        fi
    fi
    echo ""
    return 1
}

# Test basic stash functionality
test_stash_basic() {
    local file_path="${TEST_DIR}/files/file1.txt"
    
    # Verify the file exists
    assert_file_exists "$file_path" || return 1
    
    # Stash the file
    $STASH_CMD save "$file_path" -m "Test stash" > /dev/null || return 1
    
    # Verify the file no longer exists (it was moved)
    assert_not_exists "$file_path" || return 1
    
    # Verify we have one stash
    local stash_count
    stash_count=$(count_stashes)
    if [[ "$stash_count" -ne 1 ]]; then
        echo "Expected 1 stash, found $stash_count"
        return 1
    fi
    
    return 0
}

# Test stashing with copy option
test_stash_copy() {
    local file_path="${TEST_DIR}/files/file1.txt"
    
    # Verify the file exists
    assert_file_exists "$file_path" || return 1
    
    # Stash the file with copy option
    $STASH_CMD save --copy "$file_path" -m "Test copy stash" > /dev/null || return 1
    
    # Verify the file still exists (it was copied)
    assert_file_exists "$file_path" || return 1
    
    # Verify we have one stash
    local stash_count
    stash_count=$(count_stashes)
    if [[ "$stash_count" -ne 1 ]]; then
        echo "Expected 1 stash, found $stash_count"
        return 1
    fi
    
    return 0
}

# Test stashing with compression
test_stash_compress() {
    local file_path="${TEST_DIR}/files/file1.txt"
    
    # Verify the file exists
    assert_file_exists "$file_path" || return 1
    
    # Stash the file with compression
    $STASH_CMD save --compress "$file_path" -m "Test compressed stash" > /dev/null || return 1
    
    # Verify the file no longer exists (it was moved)
    assert_not_exists "$file_path" || return 1
    
    # Verify we have one stash
    local stash_count
    stash_count=$(count_stashes)
    if [[ "$stash_count" -ne 1 ]]; then
        echo "Expected 1 stash, found $stash_count"
        return 1
    fi
    
    # Verify we have a compressed file in the stash
    local stash_id
    stash_id=$(get_first_stash_id)
    assert_file_exists "${STASH_STORAGE}/${stash_id}/compressed" || return 1
    assert_file_contains "${STASH_STORAGE}/${stash_id}/compressed" "1" || return 1
    
    return 0
}

# Test stashing multiple files at once
test_stash_multiple() {
    local file1_path="${TEST_DIR}/files/file1.txt"
    local file2_path="${TEST_DIR}/files/file2.txt"
    
    # Verify the files exist
    assert_file_exists "$file1_path" || return 1
    assert_file_exists "$file2_path" || return 1
    
    # Stash multiple files
    $STASH_CMD save "$file1_path" "$file2_path" -m "Multiple files" > /dev/null || return 1
    
    # Verify the files no longer exist
    assert_not_exists "$file1_path" || return 1
    assert_not_exists "$file2_path" || return 1
    
    # Verify we have one stash
    local stash_count
    stash_count=$(count_stashes)
    if [[ "$stash_count" -ne 1 ]]; then
        echo "Expected 1 stash, found $stash_count"
        return 1
    fi
    
    return 0
}

# Test stashing a directory
test_stash_directory() {
    local dir_path="${TEST_DIR}/files/subdir1"
    
    # Verify the directory exists
    assert_dir_exists "$dir_path" || return 1
    
    # Stash the directory
    $STASH_CMD save "$dir_path" -m "Directory stash" > /dev/null || return 1
    
    # Verify the directory no longer exists
    assert_not_exists "$dir_path" || return 1
    
    # Verify we have one stash
    local stash_count
    stash_count=$(count_stashes)
    if [[ "$stash_count" -ne 1 ]]; then
        echo "Expected 1 stash, found $stash_count"
        return 1
    fi
    
    return 0
}

# Test listing stashes
test_stash_list() {
    local file_path="${TEST_DIR}/files/file1.txt"
    local message="Test list stash"
    
    # Create a stash
    $STASH_CMD save "$file_path" -m "$message" > /dev/null || return 1
    
    # Get list output
    local list_output
    list_output=$($STASH_CMD list)
    
    # Check if the list output contains our message
    if ! echo "$list_output" | grep -q "$message"; then
        echo "Stash list does not contain our message: $message"
        echo "List output:"
        echo "$list_output"
        return 1
    fi
    
    return 0
}

# Test showing stash details
test_stash_show() {
    local file_path="${TEST_DIR}/files/file1.txt"
    local message="Test show stash"
    
    # Create a stash
    $STASH_CMD save "$file_path" -m "$message" > /dev/null || return 1
    
    # Show the stash
    local show_output
    show_output=$($STASH_CMD show 1)
    
    # Check if the show output contains our message
    if ! echo "$show_output" | grep -q "$message"; then
        echo "Stash show does not contain our message: $message"
        echo "Show output:"
        echo "$show_output"
        return 1
    fi
    
    # Check if it contains the file name
    if ! echo "$show_output" | grep -q "file1.txt"; then
        echo "Stash show does not contain the file name: file1.txt"
        echo "Show output:"
        echo "$show_output"
        return 1
    fi
    
    return 0
}

# Test applying a stash
test_stash_apply() {
    local file_path="${TEST_DIR}/files/file1.txt"
    local content="Test file 1 content"
    
    # Verify the file exists
    assert_file_exists "$file_path" || return 1
    
    # Stash the file
    $STASH_CMD save "$file_path" -m "Test apply stash" > /dev/null || return 1
    
    # Verify the file no longer exists
    assert_not_exists "$file_path" || return 1
    
    # Apply the stash (with "n" to not drop it)
    echo "n" | $STASH_CMD apply 1 > /dev/null || return 1
    
    # Verify the file is restored
    assert_file_exists "$file_path" || return 1
    
    # Verify the content is correct
    assert_file_contains "$file_path" "$content" || return 1
    
    return 0
}

# Test applying a stash and choosing to drop it
test_stash_apply_and_drop() {
    local file_path="${TEST_DIR}/files/file1.txt"
    
    # Verify the file exists
    assert_file_exists "$file_path" || return 1
    
    # Stash the file
    $STASH_CMD save "$file_path" -m "Test apply and drop" > /dev/null || return 1
    
    # Verify we have one stash
    local stash_count
    stash_count=$(count_stashes)
    if [[ "$stash_count" -ne 1 ]]; then
        echo "Expected 1 stash, found $stash_count"
        return 1
    fi
    
    # Apply the stash (with "y" to drop it)
    echo "y" | $STASH_CMD apply 1 > /dev/null || return 1
    
    # Verify the file is restored
    assert_file_exists "$file_path" || return 1
    
    # Verify we now have zero stashes
    stash_count=$(count_stashes)
    if [[ "$stash_count" -ne 0 ]]; then
        echo "Expected 0 stashes, found $stash_count"
        return 1
    fi
    
    return 0
}

# Test dropping a stash
test_stash_drop() {
    local file_path="${TEST_DIR}/files/file1.txt"
    
    # Stash the file
    $STASH_CMD save "$file_path" -m "Test drop stash" > /dev/null || return 1
    
    # Verify we have one stash
    local stash_count
    stash_count=$(count_stashes)
    if [[ "$stash_count" -ne 1 ]]; then
        echo "Expected 1 stash, found $stash_count"
        return 1
    fi
    
    # Drop the stash
    $STASH_CMD drop 1 > /dev/null || return 1
    
    # Verify we now have zero stashes
    stash_count=$(count_stashes)
    if [[ "$stash_count" -ne 0 ]]; then
        echo "Expected 0 stashes, found $stash_count"
        return 1
    fi
    
    return 0
}

# Test clearing all stashes
test_stash_clear() {
    local file1_path="${TEST_DIR}/files/file1.txt"
    local file2_path="${TEST_DIR}/files/file2.txt"
    
    # Stash two files separately to create two stashes
    $STASH_CMD save "$file1_path" -m "Test clear 1" > /dev/null || return 1
    
    # Add a delay to ensure distinct timestamp in stash ID
    sleep 1
    
    $STASH_CMD save "$file2_path" -m "Test clear 2" > /dev/null || return 1
    
    # Verify we have two stashes
    local stash_count
    stash_count=$(count_stashes)
    if [[ "$stash_count" -ne 2 ]]; then
        echo "Expected 2 stashes, found $stash_count"
        return 1
    fi
    
    # Clear all stashes (with "y" to confirm)
    echo "y" | $STASH_CMD clear > /dev/null || return 1
    
    # Verify we now have zero stashes
    stash_count=$(count_stashes)
    if [[ "$stash_count" -ne 0 ]]; then
        echo "Expected 0 stashes, found $stash_count"
        return 1
    fi
    
    return 0
}

# Test error cases - stashing non-existent file
test_stash_nonexistent() {
    local file_path="${TEST_DIR}/nonexistent.txt"
    
    # Try to stash a non-existent file
    if $STASH_CMD save "$file_path" -m "Non-existent file" > /dev/null 2>&1; then
        echo "Expected failure when stashing non-existent file, but command succeeded"
        return 1
    fi
    
    # Verify we have zero stashes
    local stash_count
    stash_count=$(count_stashes)
    if [[ "$stash_count" -ne 0 ]]; then
        echo "Expected 0 stashes, found $stash_count"
        return 1
    fi
    
    return 0
}

# Test error cases - stashing the current directory
test_stash_current_dir() {
    # Debug: Print current directory
    echo "Debug: Current directory is $(pwd)"
    
    # Debug: Show initial stash count
    local initial_count
    initial_count=$(count_stashes)
    echo "Debug: Initial stash count: $initial_count"
    
    # Try to stash the current directory
    echo "Debug: Attempting to stash current directory (.)"
    local cmd_output
    cmd_output=$($STASH_CMD save "." -m "Current directory" 2>&1) || true
    echo "Debug: Command output: $cmd_output"
    
    # Debug: Check stash count after attempt
    local after_count
    after_count=$(count_stashes)
    echo "Debug: Stash count after attempt: $after_count"
    
    # Verify it failed
    if [[ "$cmd_output" != *"not allowed"* ]]; then
        echo "Expected failure message when stashing current directory"
        return 1
    fi
    
    # Verify we have zero stashes
    if [[ "$after_count" -ne 0 ]]; then
        echo "Expected 0 stashes, found $after_count"
        echo "Debug: Listing stash directory content:"
        ls -la "$STASH_STORAGE" 2>/dev/null || echo "No stash directory"
        return 1
    fi
    
    return 0
}

# Test error cases - applying non-existent stash
test_apply_nonexistent() {
    # Try to apply a non-existent stash
    if $STASH_CMD apply 999 > /dev/null 2>&1; then
        echo "Expected failure when applying non-existent stash, but command succeeded"
        return 1
    fi
    
    return 0
}

# Test error cases - dropping non-existent stash
test_drop_nonexistent() {
    # Try to drop a non-existent stash
    if $STASH_CMD drop 999 > /dev/null 2>&1; then
        echo "Expected failure when dropping non-existent stash, but command succeeded"
        return 1
    fi
    
    return 0
}

# Test error cases - showing non-existent stash
test_show_nonexistent() {
    # Try to show a non-existent stash
    if $STASH_CMD show 999 > /dev/null 2>&1; then
        echo "Expected failure when showing non-existent stash, but command succeeded"
        return 1
    fi
    
    return 0
}

# Main test runner
run_tests() {
    log "Starting test suite for stash script: $STASH_CMD"
    log "Using temporary directory: $TEST_DIR"
    
    # Basic functionality tests
    run_test "Basic stash functionality" test_stash_basic
    run_test "Stash with copy option" test_stash_copy
    run_test "Stash with compression" test_stash_compress
    run_test "Stash multiple files" test_stash_multiple
    run_test "Stash a directory" test_stash_directory
    run_test "List stashes" test_stash_list
    run_test "Show stash details" test_stash_show
    run_test "Apply a stash" test_stash_apply
    run_test "Apply and drop a stash" test_stash_apply_and_drop
    run_test "Drop a stash" test_stash_drop
    run_test "Clear all stashes" test_stash_clear
    
    # Error case tests
    run_test "Error: Stash non-existent file" test_stash_nonexistent
    run_test "Error: Stash current directory" test_stash_current_dir
    run_test "Error: Apply non-existent stash" test_apply_nonexistent
    run_test "Error: Drop non-existent stash" test_drop_nonexistent
    run_test "Error: Show non-existent stash" test_show_nonexistent
    
    # Summarize results
    log "Test Summary:"
    log "Total: $TESTS_TOTAL"
    log "Passed: $TESTS_PASSED"
    log "Failed: $TESTS_FAILED"
    log "Skipped: $TESTS_SKIPPED"
    
    if [[ "$TESTS_FAILED" -eq 0 ]]; then
        echo -e "${GREEN}All tests passed!${RESET}"
        return 0
    else
        echo -e "${RED}Some tests failed!${RESET}"
        return 1
    fi
}

# Set up trap to clean up
trap cleanup EXIT

# Run all the tests
run_tests

exit $?
