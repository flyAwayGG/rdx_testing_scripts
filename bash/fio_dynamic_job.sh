#!/bin/bash

device=$1
log=$2

if [[ -z $device ]]; then
    echo "Set path to drive in first argument. Quit."
    exit 1
fi

if [[ -z $log ]]; then
    log="log"
    echo "Use default log file - ${log}"
fi

blocksizes=('1k' '2k' '4k' '8k' '16k' '32k' '64k' '128k' '256k' '512k' '1m')
rws=('read' 'randread')
iodepths=('500' '1000' '1500' '2000' '3000')

ioengine="libaio"
direct=1
size="2000g"
runtime=120
numjobs=1
bwavgtime=1000
outputdir="/root/fio/results"

rm -rf $outputdir
mkdir -p $outputdir
echo "=== Start fio test ===" > $log

for bs in "${blocksizes[@]}"; do
    for rw in "${rws[@]}"; do
        for iodepth in "${iodepths[@]}"; do
            fio --ioengine=${ioengine} \
                --prio=0 \
                --numjobs=${numjobs} \
                --direct=${direct} \
                --iodepth=${iodepth} \
                --runtime=${runtime} \
                --size=${size} \
                --rw=${rw} \
                --bs=${bs} \
                --name=${device} \
                --output="${outputdir}/${bs}_${rw}_${iodepth}.json" \
                --output-format=json 
                # --bwavgtime=${bwavgtime} \
                # --group_reporting \
                # --norandommap \

            echo "Complete bs=${bs}, rw=${rw}, iodepth=${iodepth}" >> $log
        done
    done
done

echo "=== End fio test ===" >> $log
