#!/bin/sh
#set -x

mediainfo=/opt/homebrew/bin/mediainfo
quiet=false
cmdname=`basename "$0"`
query='$mediainfo "$1" | awk -F": " "/Duration/{ print \$2; exit }"'
query_secs='$mediainfo --Output=JSON "$1" | jq -r .media.track[0].Duration'

usage() {
    printf "usage: %s [-qs] file ...\n" $cmdname >&2
    exit 1
}

while :; do
    getopts sq arg $@ || break
    case $arg in
        q)
            quiet=true
            ;;
        s)
            query=$query_secs
            ;;
        \?)
            usage
            ;;
    esac
done

shift `expr $OPTIND - 1`
if [ $# = 0 ]; then
    usage
fi

while [ $# != 0 ]; do
    if [ -d "$1" ]; then
        if ! $quiet; then
            printf "%s: %s is a directory\n" $cmdname "$1" >&2
        fi
        shift
        continue
    fi
    if ! $quiet; then
        printf "%s:\t" "`basename "$1"`"
    fi
    out=`eval $query`
    if ! $quiet || [ ${#out} -gt 0 ]; then
        echo $out
    fi
    shift
done
