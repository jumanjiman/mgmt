# common settings and functions for test scripts

if [[ $(uname) == "Darwin" ]] ; then
	export timeout="gtimeout"
else
	export timeout="timeout"
fi

fail_test() {
	echo "FAIL: $@"
	exit 1
}

indent() {
	while IFS='' read -r line; do
		echo -e "\\t${line}"
	done < <(echo "$*")
}

err() {
	echo -e "[ERROR] $*"
}

info() {
	echo -e "[INFO] $*"
}

warn() {
	echo -e "[WARN] $*"
}

is_git_dirty() {
	! [[ "$(git status 2>&1)" =~ working\ directory\ clean ]]
}
