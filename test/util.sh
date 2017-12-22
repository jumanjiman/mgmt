# common settings and functions for test scripts

if [[ $(uname) == "Darwin" ]] ; then
	export timeout="gtimeout"
else
	export timeout="timeout"
fi

fail_test()
{
	echo "FAIL: $@"
	exit 1
}

indent() {
	while IFS='' read -r line; do
		echo -e "\\t${line}"
	done < <(echo "$*")
}
