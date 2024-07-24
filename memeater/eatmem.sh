#!/bin/sh
oseq=${OUTER_SEQ:-1000}
iseq=${INNER_SEQ:-100000}
li=${LOOP_INTERVAL:-1000000} # in microseconds
ali=${AFTER_LOOP_INTERVAL:-2600} # in seconds
echo "$$ : begin allocating memory: outer seq=${oseq}, inner seq=${iseq}, loop interval=${li}µs..."
for index in $(seq ${oseq}); do
    echo "$$ : ${index}"
    value=$(seq -w -s '' ${index} $((${index} + ${iseq})))
    eval array${index}=${value}
    usleep ${li}
done
echo "$$ : ...end allocating memory"
if [ "${ali}" = "forever" ]; then
    echo "$$ : sleeping ${ali}"
    while true; do
        echo "$$ : $(date)"
        sleep 60
    done
else
    echo "$$ : sleeping for ${ali}s before exiting"
    sleep ${ali}
fi
