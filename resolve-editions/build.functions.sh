set -euo pipefail ${RUNNER_DEBUG:+-x}

# Checks if we should build the OSS artefacts.
# Returns "true" if we should build it or "false" if we shouldn't.
function should_build_oss() {

  local release_type=$1
  if [[ $release_type =~ ^(ALL|OSS)$ ]]; then
    echo "true"
  else
    echo "false"
  fi
}

# Checks if we should build EE artefacts.
function should_build_ee() {

  local release_type=$1
  if [[ $release_type =~ ^(ALL|EE)$ ]]; then
    echo "true"
  else
    echo "false"
  fi
}
