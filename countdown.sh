function _curr-timeval() {
	date +'%s'
}

function _countdown() {
	local TIMEVAL=$1
	echo 'Now:              '$(date)
	echo 'Counting down to: '$(date --date="@$TIMEVAL")
	
	while true ; do
		local CURR_TIMEVAL=$(_curr-timeval)
		local DELAY=$((TIMEVAL - CURR_TIMEVAL))
		if ! [ $DELAY -gt 0 ] ; then
			break
		fi
		echo -ne "$DELAY \r"
		sleep 1
	done
	echo ' '
}

function countdown() {
	local DELAY=$1
	if [ "$DELAY" == "" ] ; then
		echo "Expected parameter in seconds!" >&2
		return 1
	fi
	local CURR_TIMEVAL=$(_curr-timeval)
	local TIMEVAL=$((CURR_TIMEVAL + DELAY))
	_countdown $TIMEVAL
}

function countdown_to() {
	local TIME=$1
	if [ "$TIME" == "" ] ; then
		echo "Expected timestamp parameter!" >&2
		return 1
	fi
	local TIMEVAL=$(date --date="$TIME" +'%s')
	if [ "$TIMEVAL" == "" ] ; then
		return 1
	fi
	_countdown $TIMEVAL
}
