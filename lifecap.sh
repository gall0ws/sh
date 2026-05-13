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

archive() {
    cd $outputdir || exit 1
    now=(`date +'%Y %m'`)
    for i in *.mp4; do
        v=(`echo $i | sed -r 's/(....)(..).*/\1 \2/'`)
        if [ ${v[0]} = ${now[0]} ] && [ ${v[1]} = ${now[1]} ]; then
            continue
        fi
        dir="${v[0]}/${v[1]}"
        mkdir -pv $dir || exit 1
        mv -v $i $dir
    done
}

if [ "$1" = '-a' ]; then
    archive
    exit 0
fi

if [ $# != 0 ]; then
    printf "usage: %s [-a]\n" $0 >&2
    exit 64
fi

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
