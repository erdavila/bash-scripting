function countdown() {
	local COUNT=$1
	if [ "$COUNT" == "" ] ; then
		echo "Expected parameter in seconds!" >&2
		return 1
	fi
	while [ $COUNT -gt 0 ] ; do
		echo -ne "$COUNT \r"
		sleep 1
		COUNT=$((COUNT - 1))
	done
	echo ' '
}


function countdown_to() {
	local TIME=$1
	if [ "$TIME" == "" ] ; then
		echo "Expected timestamp parameter!" >&2
		return 1
	fi
	echo 'Now:              '$(date)
	echo 'Counting down to: '$(date --date="$TIME")
	TIME=$(date --date="$TIME" +'%s')
	
	local CURR_TIME=$(date +'%s')
	COUNT=$((TIME - CURR_TIME))
	while [ $COUNT -gt 0 ] ; do
		echo -ne "$COUNT \r"
		sleep 1
		CURR_TIME=$(date +'%s')
		COUNT=$((TIME - CURR_TIME))
	done
	echo ' '
}
