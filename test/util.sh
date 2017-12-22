# common settings and functions for test scripts

if [[ $(uname) == "Darwin" ]] ; then
	export timeout="gtimeout"
else
	export timeout="timeout"
fi

fail_test() {
	fail "${*:-$0}"
	exit 1
}

pass_test() {
	pass "${*:-$0}"
	exit 0
}

indent() {
	while IFS='' read -r line; do
		echo -e "\\t${line}"
	done < <(echo "$*")
}

err() {
	echo -e "[ERROR] $*"
}

fail() {
	echo -e "[FAIL] $*"
}

info() {
	echo -e "[INFO] $*"
}

pass() {
	echo -e "[PASS] $*"
}

warn() {
	echo -e "[WARN] $*"
}

is_git_dirty() {
	! [[ "$(git status 2>&1)" =~ working\ directory\ clean ]]
}

finish() {
	declare -ri RC=$?

	if [ ${RC} -eq 0 ]; then
		pass_test
	else
		fail_test "$0 failed with exit code ${RC}"
	fi
}

handle_err() {
	declare -ri RC=$?

	# $BASH_COMMAND contains the command that was being executed at the time of the trap
	# ${BASH_LINENO[0]} contains the line number in the script of that command
	err "exit code ${RC} from \"${BASH_COMMAND}\" on line ${BASH_LINENO[0]}"
}

# Traps.
# NOTE: In POSIX, beside signals, only EXIT is valid as an event.
#       You must use bash to use ERR.
#       If you "set -e" (errexit), you must also "set -E" (errtrace).
trap finish EXIT
trap handle_err ERR
