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

declare -i RC=0

is_shell() {
	declare -r file="$1"
	file --mime --dereference "${file}" | grep 'shellscript' &> /dev/null
}

while IFS='' read -r -d '' file; do
	if ! is_shell "${file}"; then
		continue
	fi

	if [[ "${file}" =~ misc/delta-cpu.sh ]]; then
		# TODO: Don't skip this file.
		continue
	fi

	# search for more than one leading space, to ensure we use tabs
	if grep -q '^  ' "$file"; then
		err "$file should use tabs, not spaces, for indentation."
		RC=1
	fi

	# This is arbitrary to promote consistency.
	if ! [[ $(sed -n '1p' "$file") =~ ^\#!/bin/bash$ ]]; then
		err "$file should have '#!/bin/bash' as the shebang."
		RC=1
	fi

	# set -e (errexit) so we exit on error
	# set -E (errtrace) is needed for traps
	# set -u to avoid unbound variables
	if ! [[ $(sed -n '2p' "$file") =~ set\ -eEu ]]; then
		err "$file needs \"set -eEu\""
		RC=1
	fi

	# set -o pipeline means every command in pipeline must exit 0
	# and forces us to write robust scripts.
	if ! [[ $(sed -n '3p' "$file") =~ set\ -o\ pipefail ]]; then
		err "$file needs \"set -o pipefail\""
		RC=1
	fi
done < <(git ls-files -z)
exit $RC
