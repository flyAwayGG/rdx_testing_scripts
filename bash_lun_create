#!/bin/bash
rdcli raid create -n R1 -d 0,1,2,3 -l 0 -cs 2048 > /dev/null
rdcli raid create -n R2 -d 4,5,6,7 -l 0 -cs 2048 > /dev/null

LUN_COUNT=100
for ((i=0;i<LUN_COUNT;i++)); do
	echo "=============="
	rdcli lun create -n lun$i -r R1 -s 1 > /dev/null
	echo "lun$i created"

	rdcli lun extend -n lun$i -a R2 > /dev/null
	echo "lun$i extended"
done
