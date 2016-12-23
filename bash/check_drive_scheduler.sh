#/bin/bash 
### Check established scheduler on raid drives ###

# Storage drives must have deadline scheduler
DRIVES="$(rdcli d s | grep name | cut -f2 -d"|")"

# System drive must have cfq scheduler
DRIVES+='sda'

for DRIVE in $DRIVES; do
    echo -n "$DRIVE:"

	# Scheduler value        
	cat /sys/block/"$DRIVE"/queue/scheduler | cut -f2 -d"[" | cut -f1 -d"]"

    # Scheduler changing time
	ls -l /sys/block/"$DRIVE"/queue/scheduler | cut -c36-40

    echo ""
done

