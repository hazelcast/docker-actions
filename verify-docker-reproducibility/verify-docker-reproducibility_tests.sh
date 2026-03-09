#!/usr/bin/env bash

set -eu ${RUNNER_DEBUG:+-x}

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Source the latest version of assert.sh unit testing library and include in current shell
source /dev/stdin <<< "$(curl --silent https://raw.githubusercontent.com/hazelcast/assert.sh/main/assert.sh)"

TESTS_RESULT=0

log_header "Tests for verify-docker-reproducibility"

log_header "Should exit 1 when no arguments provided"
"$SCRIPT_DIR"/verify-docker-reproducibility.sh && true
actual_exit_code=$?
assert_eq 1 "$actual_exit_code" "Should exit 1 when no args given" && log_success "Exits 1 with no args" || TESTS_RESULT=$?

log_header "Should pass for a reproducible image"
"$SCRIPT_DIR"/verify-docker-reproducibility.sh "$SCRIPT_DIR/test-data/reproducible.Dockerfile" "$SCRIPT_DIR/test-data" && true
actual_exit_code=$?
assert_eq 0 "$actual_exit_code" "Should exit 0 for reproducible build" && log_success "Reproducible build passes" || TESTS_RESULT=$?

log_header "Should fail for a non-reproducible image"
"$SCRIPT_DIR"/verify-docker-reproducibility.sh "$SCRIPT_DIR/test-data/non-reproducible.Dockerfile" "$SCRIPT_DIR/test-data" && true
actual_exit_code=$?
assert_eq 1 "$actual_exit_code" "Should exit 1 for non-reproducible build" && log_success "Non-reproducible build fails" || TESTS_RESULT=$?

assert_eq 0 "$TESTS_RESULT" "All tests should pass"
