# Returns the base image of the specified Dockerfile
function get_base_image_name() {
  local dockerfile=$1

  # Read the last `FROM` line
  local line
  line=$(grep '^FROM ' "${dockerfile}" | tail -n 1)
  cut -d' ' -f2 <<< "${line}"
}
