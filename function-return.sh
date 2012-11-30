#!/bin/bash
set -e


exec {STDOUT}>&1


function func() {
	echo 'This should go to standard output' >&$STDOUT
	echo 'This should go to error output' >&2
	echo 'This should be returned by the function'
}

VALUE=$(func)
echo "The function returned \"$VALUE\""


exec {STDOUT}>&-
