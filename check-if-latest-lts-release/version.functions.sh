function __get_tags_descending() {
  local github_repository=$1

  gh api repos/${github_repository}/tags \
    --paginate \
    --jq '.[].name | select(startswith("v") and (contains("-") | not))' | \
    sort -V -r
}

function __file_exists_in_tag() {
  local github_repository=$1
  local file=$2
  local tag=$3

  gh api "repos/${github_repository}/contents/${file}?ref=${tag}" --method HEAD 2>/dev/null
}

function get_last_version_with_file() {
  local github_repository=$1
  local file=$2

  for tag in $(__get_tags_descending "${github_repository}" ); do
    if __file_exists_in_tag "${github_repository}" "${file}" "${tag}"; then
      echo "${tag}" | cut -c2-
      return
    fi
  done
}
