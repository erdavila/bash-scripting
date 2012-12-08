#!/bin/bash
# Shows samples of reading and writing to file via file descriptors and redirections
set -e
. display-and-execute.inc.sh

FILENAME=file.txt
ECHO_FILE_DESCRIPTORS_CMD='ls -l --color /proc/self/fd'


function echo_file_descriptors() {
	echo-and-execute-command "$ECHO_FILE_DESCRIPTORS_CMD"
}

function execute_fd() {
	local DESCRIPTION="$1"
	local COMMAND=$2
	local VARNAME=$3
	execute "$DESCRIPTION" "$COMMAND"
	if [ "$VARNAME" != "" ] ; then
		echo-and-execute-command "echo \$$VARNAME"
	fi
	echo_file_descriptors
}


execute "List initial file descriptors"\
	"$ECHO_FILE_DESCRIPTORS_CMD"

execute_fd "Open file \"$FILENAME\" for writing with a file descriptor"\
	"exec {FD_OUT}>$FILENAME"\
	FD_OUT

execute 'Write a line to the file descriptor'\
	'echo First line >&$FD_OUT'

execute_fd 'Duplicate the output file descriptor'\
	'exec {FD_OUT2}>&$FD_OUT'\
	FD_OUT2

execute 'Write a line to the second output file descriptor'\
	'echo Second line >&$FD_OUT2'

execute_fd 'Replace the first output file descriptor'\
	'exec {FD_OUT3}>&$FD_OUT-'\
	FD_OUT3

execute 'Write a line to the third output file descriptor'\
	'echo Third line >&$FD_OUT3'

execute 'Show file content'\
	"cat $FILENAME"

execute_fd "Open file \"$FILENAME\" for reading with a new file descriptor"\
	"exec {FD_IN}<$FILENAME"\
	FD_IN

execute 'Read a line from the input file descriptor'\
	'read LINE <&$FD_IN ; echo $LINE'

execute_fd 'Replace the input file descriptor'\
	'exec {FD_IN2}<&$FD_IN-'\
	FD_IN2

execute 'Read a line from the second input file descriptor'\
	'read LINE <&$FD_IN2 ; echo $LINE'

execute_fd 'Duplicate the input file descriptor'\
	'exec {FD_IN3}<&$FD_IN2'\
	FD_IN3

execute 'Read a line from the last input file descriptor'\
	'read LINE <&$FD_IN3 ; echo $LINE'

execute_fd 'Close the second output file descriptor'\
	'exec {FD_OUT2}>&-'

execute_fd 'Close the third output file descriptor'\
	'exec {FD_OUT3}>&-'

execute_fd 'Close the input file descriptors'\
	'exec {FD_IN2}<&- {FD_IN3}<&-'


rm $FILENAME
