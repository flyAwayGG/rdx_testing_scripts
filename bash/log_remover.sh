#!/bin/bash
### Clear logs and delete archives ###

LOG_PATH="/var/log/"

# Print all files in directory recursively
ALL_FILES=( $(find ${LOG_PATH} -type f -follow) )

ARCHIVES_DELETED=0
LOGS_CLEARED=0
for FILE in ${ALL_FILES[@]}; do
	# Comparing with glob
	if [[ $FILE == *.gz ]]
	then	
		rm -f $FILE
		echo "$FILE deleted"
		((ARCHIVES_DELETED++))
	else
		echo "Cleared on $(date)" > $FILE
		((LOGS_CLEARED++))
	fi		
done

echo "Total logs = ${#ALL_FILES[@]}"
echo "Archives deleted = $ARCHIVES_DELETED"
echo "Logs cleared = $LOGS_CLEARED"
