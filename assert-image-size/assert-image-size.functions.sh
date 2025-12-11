function assert_image_size() {
  local image=$1
  local minimum_efficiency=$2

  local config_file
  config_file=$(mktemp)

  # https://github.com/wagoodman/dive/blob/main/README.md#ci-integration
  yq eval -n "
    .rules.lowestEfficiency = ${minimum_efficiency} |
    .rules.highestWastedBytes = \"disabled\" |
    .rules.highestUserWastedPercent = \"disabled\"
  " > "${config_file}"

  docker run --rm \
    --env CI=true \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume "${config_file}:/.dive-ci" \
    docker.io/wagoodman/dive:latest \
    "${image}"

  return $?
}
