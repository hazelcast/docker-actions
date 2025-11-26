function __get_tags_descending() {
  local github_repository=$1

  # Don't use GH as cross-repo querying doesn't work with default github.token
  curl --silent "https://api.github.com/repos/${github_repository}/tags?per_page=100" \
    --paginate \
    --jq '.[].name | select(startswith("v") and (contains("-") | not))' | \
    sort -V -r
}

function __file_exists_in_tag() {
  local github_repository=$1
  local file=$2
  local tag=$3
 
  # Don't use GH as cross-repo querying doesn't work with default github.token
  # TODO 2>/dev/null
  curl --silent --HEAD --fail "https://api.github.com/repos/${github_repository}/contents/${file}?ref=${tag}"
}

function get_last_version_with_file() {
  local github_repository=$1
  local file=$2

  # TODO REMOVE
  __get_tags_descending "${github_repository}"

  for tag in $(__get_tags_descending "${github_repository}" ); do
    if __file_exists_in_tag "${github_repository}" "${file}" "${tag}"; then
      echo "${tag}" | cut -c2-
      return
    fi
  done
}
