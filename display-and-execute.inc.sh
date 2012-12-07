NOCOLOR=$'\e[0m'
BLACK=$'\e[30;1m'
RED=$'\e[31;1m'
GREEN=$'\e[32;1m'
BLUE=$'\e[34;1m'
YELLOW=$'\e[33;1m'
MAGENTA=$'\e[35;1m'
CYAN=$'\e[36;1m'
WHITE=$'\e[37;1m'


function echo-description() {
	local DESCRIPTION="$1"
	echo
	echo $MAGENTA'#' $DESCRIPTION$NOCOLOR
}

function echo-and-execute-command() {
	local COMMAND="$1"
	echo "$GREEN"'$'"$YELLOW $COMMAND$NOCOLOR"
	eval "$COMMAND"
}

function execute() {
	echo-description "$1"
	
	shift
	for command ; do
		echo-and-execute-command "$command"
	done
}
