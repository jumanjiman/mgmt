#!/bin/bash
set -eEu
set -o pipefail

################################################################################
# Test for whitespace errors and leftover conflict markers.
################################################################################

. test/util.sh

info "running $0"

declare -i RC=0
declare output

# This command identifies whitespace errors and leftover conflict markers.
# It works only on committed files, so we have to warn on dirty git tree.
output="$(git diff-tree --check "$(git hash-object -t tree /dev/null)" HEAD)"
readonly output

if [[ -n "${output}" ]]; then
	RC=1
	err "Found whitespace errors. See below."
	indent "${output}"
fi

if is_git_dirty; then
	err "Git repo has uncommitted changes. Commit or stash changes, then re-run tests."
	indent "$(git status)"
	RC=1
fi
exit $RC
