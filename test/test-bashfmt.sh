#!/bin/bash
set -eEu
set -o pipefail

################################################################################
# check for any bash files that aren't properly formatted
# TODO: this is hardly exhaustive
################################################################################

. test/util.sh

info "running $0"

ROOT=$(dirname "${BASH_SOURCE}")/..

cd "${ROOT}"

find_files() {
	git ls-files | grep -e '\.sh$' -e '\.bash$' | grep -v 'misc/delta-cpu.sh'
}

bad_files=$(
	for i in $(find_files); do
		# search for more than one leading space, to ensure we use tabs
		if grep -q '^  ' "$i"; then
			echo "$i"
		fi
	done
)

if [[ -n "${bad_files}" ]]; then
	fail_test "The following bash files are not properly formatted: ${bad_files}"
fi
