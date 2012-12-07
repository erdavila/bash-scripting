#!/bin/bash
. display-and-execute.inc.sh


execute 'Indirect expansion'\
	'VARIABLE=value ; VARNAME=VARIABLE'\
	'echo "The value of ${VARNAME} is [${!VARNAME}]"'

execute 'Use default values'\
	'unset UNSET_VAR ; NULL_VAR="" ; SET_VAR="some value"'\
	'echo "UNSET_VAR: ${UNSET_VAR:-the variable is null or unset}"'\
	'echo "NULL_VAR:  ${NULL_VAR:-the variable is null or unset}"'\
	'echo "SET_VAR:   ${SET_VAR:-the variable is null or unset}"'\
	'echo "UNSET_VAR: ${UNSET_VAR-the variable is unset}"'\
	'echo "NULL_VAR:  ${NULL_VAR-the variable is unset}"'\
	'echo "SET_VAR:   ${SET_VAR-the variable is unset}"'\

execute 'Assign default values (for unset or null)'\
	'unset UNSET_VAR ; NULL_VAR="" ; SET_VAR="some value"'\
	'echo "UNSET_VAR: ${UNSET_VAR:=new value for null or unset variable}"'\
	'echo "UNSET_VAR: $UNSET_VAR"'\
	'echo "NULL_VAR:  ${NULL_VAR:=new value for null or unset variable}"'\
	'echo "NULL_VAR:  $NULL_VAR"'\
	'echo "SET_VAR:   ${SET_VAR:=new value for null or unset variable}"'\
	'echo "SET_VAR:   $SET_VAR"'\

execute 'Assign default values (for unset)'\
	'unset UNSET_VAR ; NULL_VAR="" ; SET_VAR="some value"'\
	'echo "UNSET_VAR: ${UNSET_VAR=new value for null or unset variable}"'\
	'echo "UNSET_VAR: $UNSET_VAR"'\
	'echo "NULL_VAR:  ${NULL_VAR=new value for null or unset variable}"'\
	'echo "NULL_VAR:  $NULL_VAR"'\
	'echo "SET_VAR:   ${SET_VAR=new value for null or unset variable}"'\
	'echo "SET_VAR:   $SET_VAR"'\

execute 'Display error'\
	'unset UNSET_VAR ; NULL_VAR="" ; SET_VAR="some value"'\
	'( echo "UNSET_VAR: ${UNSET_VAR:?the variable is null or unset}" ) 2>&1'\
	'( echo "NULL_VAR:  ${NULL_VAR:? the variable is null or unset}" ) 2>&1'\
	'( echo "SET_VAR:   ${SET_VAR:?  the variable is null or unset}" ) 2>&1'\
	'( echo "UNSET_VAR: ${UNSET_VAR?the variable is unset}" ) 2>&1'\
	'( echo "NULL_VAR:  ${NULL_VAR? the variable is unset}" ) 2>&1'\
	'( echo "SET_VAR:   ${SET_VAR?  the variable is unset}" ) 2>&1'\

execute 'Use alternate value'\
	'unset UNSET_VAR ; NULL_VAR="" ; SET_VAR="some value"'\
	'echo "UNSET_VAR: ${UNSET_VAR:+the variable is not null nor unset}"'\
	'echo "NULL_VAR:  ${NULL_VAR:+ the variable is not null nor unset}"'\
	'echo "SET_VAR:   ${SET_VAR:+  the variable is not null nor unset}"'\
	'echo "UNSET_VAR: ${UNSET_VAR+the variable is not unset}"'\
	'echo "NULL_VAR:  ${NULL_VAR+ the variable is not unset}"'\
	'echo "SET_VAR:   ${SET_VAR+  the variable is not unset}"'\

execute 'Substring expansion'\
	'VARIABLE="0123456789"'\
	'echo ${VARIABLE:3}'\
	'echo ${VARIABLE: -3}'\
	'echo ${VARIABLE:3:4}'\
	'echo ${VARIABLE: -6:4}'\
	'echo ${VARIABLE:3:-2}'\
	'echo ${VARIABLE: -9:-3}'\

execute 'Parameter length'\
	'VARIABLE="some value"'\
	'echo "The value of the variable VARIABLE has ${#VARIABLE} characters"'\

execute 'Remove matching prefix pattern'\
	'VARIABLE="I am what I am or not"'\
	'echo ${VARIABLE#I*am}'\
	'echo ${VARIABLE##I*am}'\

execute 'Remove matching suffix pattern'\
	'VARIABLE="You know that I am what I am"'\
	'echo ${VARIABLE%I*am}'\
	'echo ${VARIABLE%%I*am}'\

execute 'Pattern substitution'\
	'VARIABLE="He knows that I am what I am"'\
	'echo ${VARIABLE/I am/you are}'\
	'echo ${VARIABLE//I am/you are}'\
	'echo ${VARIABLE/#I am/you are}'\
	'echo ${VARIABLE/#He /She }'\
	'echo ${VARIABLE/%I am/you are}'\
	'echo ${VARIABLE/ I am what}'\

execute 'Case modification'\
	'LOWER="some lowercase letters"'\
	'UPPER="SOME UPPERCASE LETTERS"'\
	'echo ${LOWER^[xls]}  ${UPPER,[XLS]}'\
	'echo ${LOWER^^[xls]} ${UPPER,,[XLS]}'\
	'echo ${LOWER^^[a-e]} ${UPPER,,[A-E]}'\
	'echo ${LOWER^}       ${UPPER,}'\
	'echo ${LOWER^^}      ${UPPER,,}'\
