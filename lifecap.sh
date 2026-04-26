#!/bin/sh
#set -x

## Capture a short video of your screen about every 60±10 minutes.

baseinterval=3600
variation=600
videolen=10
outputfmt=%Y%m%d%H%M
outputdir=~/video/lifecap
lockf=/tmp/lifecap.lock

if [ -e $lockf ]; then
    exit 0
fi

removelock () {
    rm $lockf
}

touch $lockf
trap removelock EXIT

while true; do
    sleep `expr $baseinterval + $RANDOM % 600 - $RANDOM % 600`
    screencapture -v -V $videolen -k -C "$outputdir/`date +$outputfmt`.mov"
done
