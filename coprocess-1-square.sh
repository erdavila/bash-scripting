#!/bin/bash
# Uses a coprocess to calculate the square of numbers (why would someone do this?! :-p)

coproc SQUARE {
	while read NUMBER ; do
		RESULT=$(($NUMBER * $NUMBER))
		echo $RESULT
	done
}
# At this point, SQUARE is an array with two subscripts:
#   SQUARE[0] is an  input fd connected via a pipe to the coprocess stdout
#   SQUARE[1] is an output fd connected via a pipe to the coprocess stdin 


while read -e -p 'Type an integer number: ' NUM ; do
	echo $NUM >&${SQUARE[1]}
	
	read -u ${SQUARE[0]} RES
	echo "Its square is $RES"
	
	echo
done
