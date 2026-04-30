version_less_or_equal() {
  local ADD_DASH_TO_FINAL_VERSION='/-/!{s/$/_/}'
  local v1=$(echo "$1" | sed $ADD_DASH_TO_FINAL_VERSION)
  local v2=$(echo "$2" | sed $ADD_DASH_TO_FINAL_VERSION)
  [ "$v1" = "$(echo -e "$v1\n$v2" | sort -V | head -n1)" ]
}

version_less_than() {
  [ "$1" != "$2" ] && version_less_or_equal "$1" "$2"
}

get_supported_jdks() {
  # Strip any pre-release metadata 
  local hz_version="${1%%-*}"
  if version_less_than "${hz_version}" "5.4.0"; then
    echo "['11', '17']"
  elif version_less_than "${hz_version}" "5.7.0"; then
    echo "['17', '21']"
  else
    echo "['17', '21', '25']"
  fi
}
