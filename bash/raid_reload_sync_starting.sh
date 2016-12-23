#!/bin/bash
### AVRORA-17269

### Make raid reload if sync state = "Starting"

RAID_NAME="raid1"
SYNC_PATH="/sys/devices/RAIDIX/RAIDIXdevice0/parameters/sync"

while true; do
	SYNC_STATE=$(<${SYNC_PATH})
	echo $SYNC_STATE
	if [[ $SYNC_STATE = "Starting" ]]; then
		rdcli raid reload -n $RAID_NAME -f
	fi
	sleep 0.1
done 
