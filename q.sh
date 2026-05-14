#!/bin/sh

SIGN_A=${SIGN_A:-\'}
SIGN_B=${SIGN_B:-$SIGN_A}

usage() {
    echo "usage: $0 [ -s sign | -a open_sign -b close_sign ] [ text ... ]" >&2
    exit 64
}

count=0
while :; do
    getopts s:a:b: opt $@ || break
    case $opt in
        s)
            SIGN_A=$OPTARG
            SIGN_B=$OPTARG
            let count+=2
            ;;
        a)
            SIGN_A=$OPTARG
            let count+=2
            ;;

        b)
            SIGN_B=$OPTARG
            let count+=2
            ;;
        \?)
            usage
            ;;
    esac
done
shift $count

if [ "$1" = "--" ]; then
    shift
fi
if [ $# = 0 ] || [ $# = 1 -a "$1" = "-" ]; then
    sed -r `printf 's/.*/%s&%s/' ${SIGN_A} ${SIGN_B}`
else
    echo ${SIGN_A}${@}${SIGN_B}
fi
