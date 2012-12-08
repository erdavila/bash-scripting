#!/bin/bash
set -e
. display-and-execute.inc.sh

execute 'Define an array'\
	'ARRAY=("1st value" [2]="at 2" "at 3" [10]="last")'\
	'ARRAY[7]=seven'\
	'echo $ARRAY'\

execute 'Values with absolute indexes'\
	'echo ${ARRAY[0]}'\
	'echo ${ARRAY[2]}'\
	'echo ${ARRAY[3]}'\
	'echo ${ARRAY[7]}'\
	'echo ${ARRAY[10]}'\

execute 'Values with indexes relative to the last'\
	'echo ${ARRAY[-11]}'\
	'echo ${ARRAY[-9]}'\
	'echo ${ARRAY[-8]}'\
	'echo ${ARRAY[-4]}'\
	'echo ${ARRAY[-1]}'\

execute 'All members'\
	'(echo ${ARRAY[*]} ; export IFS=/ ; echo "${ARRAY[*]}")'\
	'(echo ${ARRAY[@]} ; export IFS=/ ; echo "${ARRAY[@]}")'\

execute 'Iterate'\
	'for VAL in ${ARRAY[*]} ; do echo -n [$VAL] ; done ; echo'\
	'for VAL in ${ARRAY[@]} ; do echo -n [$VAL] ; done ; echo'\
	'for VAL in "before ${ARRAY[*]} after" ; do echo -n [$VAL] ; done ; echo'\
	'for VAL in "before ${ARRAY[@]} after" ; do echo -n [$VAL] ; done ; echo'\

execute 'Lengths'\
	'for I in 0 2 3 7 10 ; do echo "The length of [${ARRAY[$I]}] is ${#ARRAY[$I]}" ; done'\

execute 'Number of elements'\
	'echo ${#ARRAY[*]} or ${#ARRAY[@]}'\

execute 'Subarray'\
	'for VAL in ${ARRAY[*]:3:2} ; do echo -n [$VAL] ; done ; echo'\
	'for VAL in ${ARRAY[@]:3:2} ; do echo -n [$VAL] ; done ; echo'\
	'for VAL in "before ${ARRAY[*]:3:2} after" ; do echo -n [$VAL] ; done ; echo'\
	'for VAL in "before ${ARRAY[@]:3:2} after" ; do echo -n [$VAL] ; done ; echo'\

execute 'Indexes'\
	'for VAL in ${!ARRAY[*]} ; do echo -n [$VAL] ; done ; echo'\
	'for VAL in ${!ARRAY[@]} ; do echo -n [$VAL] ; done ; echo'\
	'for VAL in "before ${!ARRAY[*]} after" ; do echo -n [$VAL] ; done ; echo'\
	'for VAL in "before ${!ARRAY[@]} after" ; do echo -n [$VAL] ; done ; echo'\

execute 'List indexes and values'\
	'for I in ${!ARRAY[@]} ; do echo [$I]=\"${ARRAY[$I]}\" ; done'\

execute 'Destroy an element'\
	'echo [${ARRAY[3]}]'\
	'unset ARRAY[3]'\
	'echo [${ARRAY[3]}]'\

# For some reason, append-assignment (+=) fails when
# eval-ed, so we need to execute it the other way...
echo-description 'Append items'
ARRAY+=("after old last" "new last")
echo-command 'ARRAY+=("after old last" "new last")'
echo-and-execute-command 'for I in ${!ARRAY[@]} ; do echo [$I]=\"${ARRAY[$I]}\" ; done'
