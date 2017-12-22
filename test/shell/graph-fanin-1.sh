#!/bin/bash
set -eEu
set -o pipefail

# should take more than 25s plus overhead
$timeout --kill-after=50s 45s ./mgmt run --yaml graph-fanin-1.yaml --converged-timeout=5 --no-watch --tmp-prefix --no-pgp &
pid=$!
wait $pid	# get exit status
exit $?
