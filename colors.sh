#!/bin/bash
set -e
shopt -s nocasematch


function make-code-string() {
	echo '$'"'\e[${1}m'"
}

function make-code-from-string() {
	local code
	eval "code=$1"
	echo $code
}

function make-code() {
	local code_string=$(make-code-string "$1")
	make-code-from-string $code_string
}

NOCOLOR=$(make-code 0)

FG_COLORS=$(
	for val in $(seq 30 37) ; do
		echo -n " $(make-code $val) $val $NOCOLOR"
	done
)
BG_COLORS=$(
	for val in $(seq 40 47) ; do
		echo -n " $(make-code $val) $val $NOCOLOR"
	done
)

opnames=(''
	'bold         '
	'darker       '
	'?            '
	'underline    '
	'?            '
	'?            '
	'reverse      '
	'black        '
	'strikethrough'
)


function get-value-of() {
	local VALUE
	eval 'VALUE=$'$1
	echo $VALUE
}

function set-value-of() {
	eval "$1=$2"
}

function copy-values() {
	local from=$1
	local to=$2
	
	local fg=$(get-value-of fg$from)
	set-value-of fg$to $fg
	
	local bg=$(get-value-of bg$from)
	set-value-of bg$to $bg
	
	for opnum in $(seq 1 9) ; do
		local op=$(get-value-of op${opnum}_$from)
		set-value-of op${opnum}_$to $op
	done
}

function previous-color-value() {
	if [ "$1" == "" ] ; then
		echo 7
	elif [ $1 -eq 0 ] ; then
		echo ''
	else
		echo $(($1 - 1))
	fi
}

function next-color-value() {
	if [ "$1" == "" ] ; then
		echo 0
	elif [ $1 -eq 7 ] ; then
		echo ''
	else
		echo $(($1 + 1))
	fi
}

function concat() {
	if [ "$1" == "" ] ; then
		echo $2
	else
		echo "$1;$2"
	fi
}

function not() {
	if $1 ; then
		echo false
	else
		echo true
	fi 
}


selected1=true
selected2=false
for n in 1 2 ; do
	for opnum in $(seq 1 9) ; do
		set-value-of op${opnum}_$n false
	done
done

while true ; do
	clear
		
	for n in 1 2 ; do
		selected=$(get-value-of selected$n)
		if $selected ; then
			sel_char='>'
		else
			sel_char=' '
		fi
		
		seq=''
		
		fg=$(get-value-of fg$n)
		if [ "$fg" != "" ] ; then
			seq=$(concat "$seq" "3$fg")
		fi
		
		bg=$(get-value-of bg$n)
		if [ "$bg" != "" ] ; then
			seq=$(concat "$seq" "4$bg")
		fi
		
		for opnum in $(seq 1 9) ; do
			op=$(get-value-of op${opnum}_$n)
			if $op ; then
				seq=$(concat "$seq" $opnum)
			fi
		done
		
		if [ "$seq" == "" ] ; then
			seq=0
		fi
		
		
		code_string=$(make-code-string "$seq")
		code=$(make-code "$seq")
		echo "$sel_char $code  SAMPLE  $NOCOLOR  $code_string"
		echo
	done
	
	echo
	echo "   F/G - previous/next foreground:$FG_COLORS"
	echo "   V/B - previous/next background:$BG_COLORS"
	for n in $(seq 1 9) ; do
		echo "     $n - toggle ${opnames[$n]}    : $(make-code $n) $n $NOCOLOR"
	done
	echo ' Q/A/Z - select first/both/second sample(s)'
	echo '   W/X - copy from the first/second sample to the other'
	echo '     S - swap samples'
	echo 'CTRL+C - exit'
	echo
	
	read -n 1 -r -p "Type a command " COMMAND
	echo
	
	case $COMMAND in
		F)
			for n in 1 2 ; do
				if $(get-value-of selected$n) ; then
					fg=$(get-value-of fg$n)
					fg=$(previous-color-value $fg)
					set-value-of fg$n $fg
				fi
			done 
			;;
		G)
			for n in 1 2 ; do
				if $(get-value-of selected$n) ; then
					fg=$(get-value-of fg$n)
					fg=$(next-color-value $fg)
					set-value-of fg$n $fg
				fi
			done 
			;;
		V)
			for n in 1 2 ; do
				if $(get-value-of selected$n) ; then
					bg=$(get-value-of bg$n)
					bg=$(previous-color-value $bg)
					set-value-of bg$n $bg
				fi
			done 
			;;
		B)
			for n in 1 2 ; do
				if $(get-value-of selected$n) ; then
					bg=$(get-value-of bg$n)
					bg=$(next-color-value $bg)
					set-value-of bg$n $bg
				fi
			done 
			;;
		1|2|3|4|5|6|7|8|9)
			opnum=$COMMAND
			for n in 1 2 ; do
				if $(get-value-of selected$n) ; then
					op=$(get-value-of op${opnum}_$n)
					op=$(not $op)
					set-value-of op${opnum}_$n $op
				fi
			done
			;;
		Q)
			selected1=true
			selected2=false
			;;
		A)
			selected1=true
			selected2=true
			;;
		Z)
			selected1=false
			selected2=true
			;;
		W)
			copy-values 1 2
			;;
		X)
			copy-values 2 1
			;;
		S)
			copy-values 2 tmp
			copy-values 1 2
			copy-values tmp 1
			;;
	esac
done
