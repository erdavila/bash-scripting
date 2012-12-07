#!/bin/bash
# Shows samples of reading and writing to file via file descriptors and redirections

set -e

FILENAME=file.txt

NOCOLOR=$'\e[0m'
BLACK=$'\e[30;1m'
RED=$'\e[31;1m'
GREEN=$'\e[32;1m'
BLUE=$'\e[34;1m'
YELLOW=$'\e[33;1m'
MAGENTA=$'\e[35;1m'
CYAN=$'\e[36;1m'
WHITE=$'\e[37;1m'


ECHO_FILE_DESCRIPTORS_CMD='ls -l --color /proc/self/fd'

function echo_description() {
	local DESCRIPTION="$1"
	echo
	echo $MAGENTA'#' $DESCRIPTION$NOCOLOR
}

function echo_and_execute_command() {
	local COMMAND="$1"
	echo $GREEN'$'$YELLOW $COMMAND$NOCOLOR
	eval $COMMAND
}

function echo_file_descriptors() {
	echo_and_execute_command "$ECHO_FILE_DESCRIPTORS_CMD"
}

function execute() {
	echo_description "$1"
	echo_and_execute_command "$2"
}

function execute_fd() {
	local DESCRIPTION="$1"
	local COMMAND=$2
	local VARNAME=$3
	execute "$DESCRIPTION" "$COMMAND"
	if [ "$VARNAME" != "" ] ; then
		echo_and_execute_command "echo \$$VARNAME"
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
