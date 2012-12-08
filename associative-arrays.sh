#!/bin/bash
set -e
. display-and-execute.inc.sh


# For some reason, the declare command has no effect when
# eval-ed, so we need to execute it the other way...
declare -A ARRAY
execute 'Define an array'\
	'declare -A ARRAY'\
	'ARRAY=([zero]="1st value" [two]="at 2" [three]="at 3" [ten]="last")'\
	'ARRAY[seven]=seven'

execute 'Values'\
	'echo ${ARRAY[zero]}'\
	'echo ${ARRAY[two]}'\
	'echo ${ARRAY[three]}'\
	'echo ${ARRAY[seven]}'\
	'echo ${ARRAY[ten]}'\

execute 'All members'\
	'(echo ${ARRAY[*]} ; export IFS=/ ; echo "${ARRAY[*]}")'\
	'(echo ${ARRAY[@]} ; export IFS=/ ; echo "${ARRAY[@]}")'\

execute 'Iterate on values'\
	'for VAL in ${ARRAY[*]} ; do echo -n [$VAL] ; done ; echo'\
	'for VAL in ${ARRAY[@]} ; do echo -n [$VAL] ; done ; echo'\
	'for VAL in "before ${ARRAY[*]} after" ; do echo -n [$VAL] ; done ; echo'\
	'for VAL in "before ${ARRAY[@]} after" ; do echo -n [$VAL] ; done ; echo'\

execute 'Lengths'\
	'for K in zero two three seven ten ; do echo "The length of [${ARRAY[$K]}] is ${#ARRAY[$K]}" ; done'\

execute 'Number of elements'\
	'echo ${#ARRAY[*]} or ${#ARRAY[@]}'\

execute 'List keys'\
	'for VAL in ${!ARRAY[*]} ; do echo -n [$VAL] ; done ; echo'\
	'for VAL in ${!ARRAY[@]} ; do echo -n [$VAL] ; done ; echo'\
	'for VAL in "before ${!ARRAY[*]} after" ; do echo -n [$VAL] ; done ; echo'\
	'for VAL in "before ${!ARRAY[@]} after" ; do echo -n [$VAL] ; done ; echo'\

execute 'Keys and values as indexed arrays'\
	'KEYS=("${!ARRAY[@]}")'\
	'for KEY in "${KEYS[@]}" ; do echo -n [$KEY] ; done ; echo'\
	'VALUES=("${ARRAY[@]}")'\
	'for VALUE in "${VALUES[@]}" ; do echo -n [$VALUE] ; done ; echo'\

execute 'List keys and its values'\
	'for K in ${!ARRAY[@]} ; do echo [$K]=\"${ARRAY[$K]}\" ; done'\

execute 'Destroy an element'\
	'echo [${ARRAY[three]}]'\
	'unset ARRAY[three]'\
	'echo [${ARRAY[three]}]'\
