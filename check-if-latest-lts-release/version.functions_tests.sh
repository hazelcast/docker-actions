#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Source the latest version of assert.sh unit testing library and include in current shell
source /dev/stdin <<< "$(curl --silent https://raw.githubusercontent.com/hazelcast/assert.sh/main/assert.sh)"

. "$SCRIPT_DIR"/version.functions.sh

TESTS_RESULT=0

function assert_get_last_version_with_file {
  local FILE=$1
  local EXPECTED_LAST_VERSION=$2
  local ACTUAL_LAST_VERSION
  ACTUAL_LAST_VERSION=$(get_last_version_with_file "hazelcast/hazelcast-docker" "${FILE}")
  assert_eq "${ACTUAL_LAST_VERSION}" "${EXPECTED_LAST_VERSION}" "Last version of ${FILE} should be ${EXPECTED_LAST_VERSION:-<none>} " || TESTS_RESULT=$?
}

log_header "Tests for get_last_version_with_file"
assert_get_last_version_with_file ".github/containerscan/allowedlist.yaml" "5.3.1" # it was removed in 5.3.2
assert_get_last_version_with_file "dummy-non-existing-file" ""

assert_eq 0 "${TESTS_RESULT}" "All tests should pass"
