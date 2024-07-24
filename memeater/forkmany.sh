#!/bin/sh
nf=${NUM_FORKS:-10}
for index in $(seq ${nf}); do
    echo "$$ : $(date) : forking process # ${index}"
    AFTER_LOOP_INTERVAL=forever /home/densify/bin/eatmem.sh > /dev/null &
    usleep 500000
done
nr=${nf}
while true; do
    np=$(pgrep eatmem | wc -l)
    gap=$((nf - np))
    if [ ${gap} -gt 0 ]; then
        echo "$$ : ${gap} process(es) missing"
        for ignoreIndex in $(seq ${gap}); do
            nr=$(( nr + 1 ))
            echo "$$ : $(date) : re-launching forked process # ${nr}"
            AFTER_LOOP_INTERVAL=forever /home/densify/bin/eatmem.sh > /dev/null &
        done
    fi
    sleep 10     
done
