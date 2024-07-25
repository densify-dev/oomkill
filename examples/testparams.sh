#!/bin/sh
if [ $# -lt 2 ]; then
    echo "Usage: $0 outer_seq inner_seq"
    exit 1
fi
val1=$(seq -w -s '' 1 $((1 + ${2})) | wc -c)
val2=$(seq -w -s '' ${1} $((${1} + ${2})) | wc -c)
echo "Begin seq 1 generates ${val1} bytes"
echo "End seq ${1} generates ${val2} bytes"
if [ $val1 -eq $val2 ]; then
    echo "Values are equal"
else
    echo "Values are not equal, choose other parameters"
    exit 255
fi
