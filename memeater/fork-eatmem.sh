#!/bin/sh
bfi=${BEFORE_FORK_INTERVAL:-10} # in seconds
afi=${AFTER_FORK_INTERVAL:-360} # in seconds
echo "forking another process to eat memory after ${bfi}s..."
sleep ${bfi}
/home/densify/bin/eatmem.sh >> /proc/1/fd/1
echo "sleeping ${afi}s after memeater exited with $?"
sleep ${afi}
