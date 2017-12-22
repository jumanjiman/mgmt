#!/bin/bash
set -eEu
set -o pipefail

################################################################################
# Fail if the test environment lacks any dependencies.
################################################################################

. test/util.sh

declare -r dependencies="
	file
	go
	goimports
	golint
	sed
	which
"
declare missing_dependencies=""

for dependency in ${dependencies}; do
	if ! command -v "${dependency}" &> /dev/null; then
		missing_dependencies="${missing_dependencies} ${dependency}"
	fi
done

if [[ -n "${missing_dependencies}" ]]; then
	err "Missing dependencies:${missing_dependencies}"
	info "Try running \"make deps\"."
	exit 1
fi
