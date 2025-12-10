#!/usr/bin/env bash

set -eu ${RUNNER_DEBUG:+-x}

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Source the latest version of assert.sh unit testing library and include in current shell
source /dev/stdin <<< "$(curl --silent https://raw.githubusercontent.com/hazelcast/assert.sh/main/assert.sh)"

. "$SCRIPT_DIR"/test-image-size.functions.sh

TESTS_RESULT=0

function assert_test_image_size {
  local image=$1
  local minimum_efficiency=$2
  local expected_exit_code=$3
  test_image_size "${image}" "${minimum_efficiency}" && true
  local actual_exit_code=$?
  local msg="Expected exit code for \"${image}\" / \"${minimum_efficiency}\""
  assert_eq "${expected_exit_code}" "${actual_exit_code}" "${msg}" && log_success "${msg}" || TESTS_RESULT=$?
}

log_header "Tests for test_image_size"
# expected efficiency: 99.8541 %
assert_test_image_size hazelcast/hazelcast:5.0.1-slim 0.95 0
assert_test_image_size hazelcast/hazelcast:5.0.1-slim 0.99999999999 1

assert_eq 0 "$TESTS_RESULT" "All tests should pass"
