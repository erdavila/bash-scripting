#!/bin/bash
# Redirect parts of this script output to the less pager.


function generate_some_output() {
	echo "Numbers from $1 to $2:"
	seq $1 $2
}

function pause() {
	read -p "Press ENTER to continue "
}

function set_paged_output() {
	# Duplicate original stdout fd so that the coprocess can use it
	exec {STDOUT}>&1;

	coproc LESS {
		# At this point the stdin fd and stdout are connected to the main script via pipes
		
		# Restore the original stdout
		exec 1>&$STDOUT
		
		less
	}
	
	# At this point, LESS is an array with two subscripts:
	#   LESS[0] is an  input fd connected via a pipe to the coprocess stdout
	#   LESS[1] is an output fd connected via a pipe to the coprocess stdin 
	IN_FROM_LESS_OUT=${LESS[0]}
	OUT_TO_LESS_IN=${LESS[1]}

	# Redirect our stdout through the pipe connected to the coprocess stdin
	exec 1>&$OUT_TO_LESS_IN-
	
	# Close our input from the pipe connected to the coprocess stdout since it will not be used
	exec {IN_FROM_LESS_OUT}<&-
}

function unset_paged_output() {
	# Restore our stdout to the original.
	# The previous fd ($STDOUT) is closed. It's important because, by closing
	# our side of the pipe connected to the coprocess stdin, the less command is
	# able to know that there is no more data to receive and then it can finish.
	exec 1>&$STDOUT-

	# Wait for coprocess termination
	wait
}


generate_some_output 1 10
pause

set_paged_output
generate_some_output 11 495
unset_paged_output

pause
generate_some_output 496 505
pause

set_paged_output
generate_some_output 506 990
unset_paged_output

pause
generate_some_output 991 1000
