version_less_or_equal() {
  [ "$1" = "$(echo -e "$1\n$2" | sort -V | head -n1)" ]
}

version_less_than() {
  [ "$1" != "$2" ] && version_less_or_equal "$1" "$2"
}

get_supported_jdks() {
  local HZ_VERSION=$1
  if version_less_than "$HZ_VERSION" "5.4.0"; then
    echo "['11', '17']"
  else
    echo "['17', '21']"
  fi
}
