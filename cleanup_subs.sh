#!/bin/sh
#set -x

## Remove subtitles for already deleted videos.

subs_directories="\
        ${HOME}/video/subs      \
        ${HOME}/Movies/subs"

for dir in $subs_directories; do
    cd $dir 2>/dev/null || continue
    for i in `ls $dir`; do
        title=`echo "$i" | cut -d . -f1`
        ls .. | fgrep -q "$title" || rm -fv "$i"
    done
done
