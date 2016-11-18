#!/bin/bash
### AVRORA-17269

### Make raid reload if sync state = "Starting"
### and wait until lun on this raid don't get read_only = 1

#LUN_NAME="lunname"
### cat /sys/devices/rvm/V:lunec/parameters/read_only == "1"
### cat /sys/devices/RAIDIX/RAIDIXdevice0/parameters/sync == "Starting"
#RO_PATH="/sys/devices/rvm/V:${LUN_NAME}/parameters/read_only"

RAID_NAME="raid1"
SYNC_PATH="/sys/devices/RAIDIX/RAIDIXdevice0/parameters/sync"
LOG="/root/states.log"

iterations=0
starting_states=0

while true; do
	
	SYNC_STATE=$(<${SYNC_PATH})
	echo $SYNC_STATE | tee -a $LOG
	if [[ $SYNC_STATE = "Starting" ]]; then
		rdcli raid reload -n $RAID_NAME -f
		((starting_states++))	
	fi

	# RO_STATE=$(<${RO_PATH})
	# echo $RO_STATE | tee -a $LOG
	# if (( RO_STATE == 1 )); then
	# 	echo "Reach read only state in
	# 	${iterations} iterations
	# 	${starting_states} \"Starting\" states" | tee -a $LOG
	# 	break
	# fi
	
	((iterations++))
	sleep 0.1

done 
