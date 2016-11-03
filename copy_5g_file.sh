#!/bin/bash

INPUT_F=$1;
OUTPUT_DIR=$2;
CP_TIMES=$3;

COUNTER=0;
while [ $COUNTER -lt $CP_TIMES ]; do
	cp $INPUT_F $OUTPUT_DIR/file$COUNTER
	echo $COUNTER
	((COUNTER++))
done
