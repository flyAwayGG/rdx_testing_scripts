#!/bin/bash
# AVRORA-17230

PASSIVE="root@172.16.21.133"
RAID_NAME="raid1"
LUN_NAME="lunname"

RO_PATH="/sys/devices/rvm/V:${LUN_NAME}/parameters/read_only"
SYNC_PATH="/sys/devices/RAIDIX/RAIDIXdevice0/parameters/sync"

check_ro() {
	RO_STATE=$(<${RO_PATH})
	echo $RO_STATE 
	if (( RO_STATE == 1 )); then
		echo "Reach read only state"
		exit 1
	fi
}

while true; do
	
	state="$(rdcli r s -n $RAID_NAME | grep Passive)"
	# If active
	if [ "x$state" = "x" ]; then
		if [[ $(<${SYNC_PATH}) != "Starting" ]]; then
			rdcli raid reload -n $RAID_NAME -f
			echo "RELOAD RAID"
		fi
		#SYNC="ssh ${PASSIVE} cat ${SYNC_PATH}"

		while true; do
			sleep 0.01
			echo "SLEEP 0.01"
			if [[ $(<${SYNC_PATH}) = "Starting" ]]; then
				ssh $PASSIVE rdcli dc failover 
				echo "FAILOVER ON PASSIVE"
				break
			fi
		done

		check_ro
		sleep 31
	else

		## Set ssh to execute commands remotely 
		
		# if [[ "ssh $PASSIVE cat $SYNC_PATH" != "Starting" ]]; then
		# 	rdcli raid reload -n $RAID_NAME -f
		# 	echo "RELOAD RAID ON PASSIVE"
		# fi

		# while true; do
		# 	sleep 0.01
		# 	echo "SLEEP 0.01"
		# 	if [[ "ssh $PASSIVE cat $SYNC_PATH" = "Starting" ]]; then
		# 		ssh $PASSIVE rdcli dc failover 
		# 		echo "FAILBACK ON ACTIVE"
		# 		break
		# 	fi
		# done

		rdcli dc failback
		sleep 31
	fi
done
