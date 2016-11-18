#!/bin/bash
# AVRORA-17230

### Cast migrate on passive
### If sync = "Starting" cast migrate and check read_only state

# while true; do rdcli raid migrate -n raid1; done

RAID_NAME="raid1"
LUN_NAME="lunname"
#cat /sys/devices/rvm/V:lunname/parameters/read_only == "1"
#cat /sys/devices/RAIDIX/RAIDIXdevice0/parameters/sync == "Starting"
RO_PATH="/sys/devices/rvm/V:${LUN_NAME}/parameters/read_only"
SYNC_PATH="/sys/devices/RAIDIX/RAIDIXdevice0/parameters/sync"
LOG="/root/states.log"

iterations=0
starting_states=0

rdcli raid reload -n $RAID_NAME -f
while true; do
	
	SYNC_STATE=$(<${SYNC_PATH})
	echo $SYNC_STATE | tee -a $LOG
	if [[ $SYNC_STATE = "Starting" ]]; then
		rdcli raid migrate -n $RAID_NAME		
		((starting_states++))	
	fi 

	RO_STATE=$(<${RO_PATH})
	echo $RO_STATE | tee -a $LOG
	if (( RO_STATE == 1 )); then
		echo "Reach read only state in
		${iterations} iterations
		${starting_states} \"Starting\" states" | tee -a $LOG
		break
	fi

	((iterations++))
	sleep 0.1
done 
