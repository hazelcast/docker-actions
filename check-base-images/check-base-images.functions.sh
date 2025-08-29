source /dev/stdin <<< "$(curl --silent https://raw.githubusercontent.com/hazelcast/hazelcast-docker/master/.github/scripts/logging.functions.sh)"

# Determine if the packages in the specified image are updatable
# Returns exit code:
# 0 if the packages in the image are updatable
# 1 if the packages in the image is up-to-date
function packages_updatable_from_dockerfile() {
  local image=$1
  local dockerfile=$2

  local base_image_name
  base_image_name=$(get_base_image_name "${dockerfile}")
  packages_updatable "${image}" "${base_image_name}"
}

# Determine if the packages in the specified image are updatable
# Returns exit code:
# 0 if the packages in the image are updatable
# 1 if the packages in the image is up-to-date
function packages_updatable() {
  local image=$1
  local base_image=$2

  local output

  if [[ "${base_image}" == *"alpine"* ]]; then
    output=$(docker run --user 0 --rm "${image}" sh -c 'apk update >/dev/null && apk list --upgradeable')
    echodebug "${output}"
    [[ -n "${output}" ]]
  elif [[ "${base_image}" == *"redhat/ubi"* ]]; then
    # use assumeno as a workaround for lack of dry-run option
    output=$(docker run --user 0 --rm "${image}" sh -c "microdnf --assumeno upgrade --nodocs")
    echodebug "${output}"
    local package_upgrades
    package_upgrades=$(echo "${output}" | grep --count Upgrading)
    [[ "${package_upgrades}" -ne 0 ]]
  else
    echoerr "Unsupported base image: ${base_image}"
    exit 1
  fi
}

# Returns the base image of the specified Dockerfile
function get_base_image_name() {
  local dockerfile=$1
  # Read the (implicitly first) `FROM` line
  grep '^FROM ' "${dockerfile}" | cut -d' ' -f2
}

# Determine if the specified image is outdated when compared to it's base image
# Returns exit code:
# 0 if the current image is outdated compared to the base image
# 1 if the current image is up-to-date compared to the base image
function base_image_outdated_from_dockerfile() {
  local current_image=$1
  local dockerfile=$2

  local base_image_name
  base_image_name=$(get_base_image_name "${dockerfile}")
  base_image_outdated "${current_image}" "${base_image_name}"
}

# Determine if the specified image is outdated when compared to it's base image
# Returns exit code:
# 0 if the current image is outdated compared to the base image
# 1 if the current image is up-to-date compared to the base image
function base_image_outdated() {
  local current_image=$1
  local base_image=$2

  local base_image_sha
  base_image_sha=$(get_base_image_sha "${base_image}")
  local current_image_sha
  current_image_sha=$(get_base_image_sha "${current_image}")
  [[ "${current_image_sha}" != "${base_image_sha}" ]]
}

function get_base_image_sha() {
  local image=$1
  docker pull "${image}" --quiet
  docker image inspect --format '{{index .RootFS.Layers 0}}' "${image}"
}
