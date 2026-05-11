#!/bin/sh
#set -x

## Capture a short video of your screen about every 60±10 minutes.

interval=3600
var=600
videolen=10
outputfmt=%Y%m%d%H%M
outputdir=~/video/lifecap
ffmpeg=/opt/homebrew/bin/ffmpeg
vcodec=libx264
lockf=/tmp/lifecap.lock
pid=$$

trap "rm -f $lockf" EXIT

(

    lockf -t0 9 || exit 1
    printf "%d %d\n" $pid `date +%s` >&9

    while true; do
        sleep `expr $interval + $RANDOM % $var - $RANDOM % $var`
        vid="$outputdir/`date +$outputfmt`"
        screencapture -k -V $videolen ${vid}.mov
        nice -n 50 $ffmpeg -y -i ${vid}.mov -c:v $vcodec ${vid}.mp4
        rm ${vid}.mov
    done

) 9>>$lockf
