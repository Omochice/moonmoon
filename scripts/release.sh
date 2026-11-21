#!/usr/bin/env bash
# Publishes every workspace module to mooncakes.io, dependencies first.
#
# A module whose dry run reports the version as already published is skipped.
# Any other dry-run failure stops the run before later modules, because a module
# published after a failed dependency would point at a version the registry lacks.
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

workspace_members() {
  perl -ne 'print "$1\n" while /"\.\/([^"]+)"/g' moon.work
}

module_name() {
  perl -ne 'if (/^name\s*=\s*"([^"]+)"/) { print "$1\n"; exit }' "$1/moon.mod"
}

module_imports() {
  perl -ne 'print "$1\n" while /"([^"@\s]+)@[^"]*"/g' "$1/moon.mod"
}

# The wording is unconfirmed until a version has been published once, so a
# mismatch stops the run instead of publishing a second time.
reports_already_published() {
  grep -qiE 'already (been )?(published|exists)' <<<"$1"
}

declare -A dir_of
while read -r dir; do
  dir_of["$(module_name "$dir")"]="$dir"
done < <(workspace_members)

# tsort reads a pair of identical names as a node without an edge, which keeps
# modules that nothing depends on in the order.
dependency_pairs() {
  local name dep
  for name in "${!dir_of[@]}"; do
    echo "$name $name"
    while read -r dep; do
      if [ -n "${dir_of[$dep]:-}" ]; then
        echo "$dep $name"
      fi
    done < <(module_imports "${dir_of[$name]}")
  done
}

mapfile -t order < <(dependency_pairs | tsort)

for name in "${order[@]}"; do
  dir="${dir_of[$name]}"
  echo "==> $name ($dir)"
  if output="$(cd "$dir" && moon publish --dry-run 2>&1)"; then
    printf '%s\n' "$output"
    (cd "$dir" && moon publish)
  elif reports_already_published "$output"; then
    echo "$name is already published; skipping"
  else
    printf '%s\n' "$output" >&2
    echo "dry run of $name failed; stopping before the remaining modules" >&2
    exit 1
  fi
done
