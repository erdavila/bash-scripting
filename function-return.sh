#!/bin/bash
set -e

# Duplicate the original stdout fd so that the function can use it
exec {STDOUT}>&1


function func() {
	# At this point, the function's stdout fd (1) is redirected to be captured by the function caller
	
	# Move the return fd (from 1 to $RETURN)
	exec {RETURN}>&1-
	
	# Restore the original stdout (duplicates $STDOUT to 1)
	exec 1>&$STDOUT
	
	echo 'This should go to standard output'
	echo 'This should go to error output' >&2
	echo 'This should be returned by the function' >&$RETURN
	
	# Close the return fd ($RETURN)
	#exec {RETURN}>&-  # Not really needed!
}


echo "The function returned \"$(func)\""


# Close the duplication ($STDOUT) of the original stdout fd
exec {STDOUT}>&-
