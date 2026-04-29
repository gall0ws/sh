#!/bin/sh
#set -x

mediainfo=/opt/homebrew/bin/mediainfo
quiet=false

if [ "$1" = "-q" ]; then
    quiet=true
    shift
fi

if [ $# = 0 ]; then
    printf "usage: %s [-q] file ...\n" `basename $0` >&2
    exit 1
fi

while [ $# != 0 ]; do
    if ! $quiet; then
        printf "%s:\t" `basename $1`
    fi
    out=`$mediainfo "$1" | awk -F': ' '/Duration/{ print $2; exit }'`
    if ! $quiet || [ ${#out} -gt 0 ]; then
        echo $out
    fi
    shift
done
