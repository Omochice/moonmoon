#!/usr/bin/env bash
# Runs mutation testing on every workspace module and fails when a module's
# mutation score drops below its threshold.
#
# Each threshold sits a few points under the score the module last reached.
# A threshold equal to the score would turn one slow runner, where a killed
# mutant exceeds the timeout instead, into a failure with no change to the code.
# A module without a threshold gets turtles' own rule: any survivor fails.
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

declare -A fail_under=(
  [keyring]=65
  [mcp]=85
  [schema]=95
)

workspace_members() {
  perl -ne 'print "$1\n" while /"\.\/([^"]+)"/g' moon.work
}

if [ ! -d "${MOON_HOME:-$HOME/.moon}/registry/index" ]; then
  moon update
fi

status=0
while read -r dir; do
  # --timeout-multiplier is not used: its 10-second floor is shorter than a
  # mutant's native rebuild when every core builds one, and mcp then reports
  # most of its mutants as timed out.
  args=(--dir "$dir" --jobs "$(nproc)")
  if [ -n "${fail_under[$dir]:-}" ]; then
    args+=(--fail-under "${fail_under[$dir]}")
  fi
  echo "::group::turtles ${args[*]}"
  turtles "${args[@]}" || status=1
  echo "::endgroup::"
done < <(workspace_members)

exit "$status"
