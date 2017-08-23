#!/bin/sh

#set -x

esc_font='710'
esc_boldfont='711'

cmd=$0
escape=$esc_font
xlfd=

_usage() {
    echo "usage: $cmd [-b] FONTNAME [PIXELSIZE [WEIGHT]]"
    echo "       $cmd [-b] -x XLFD"
}

_set() {
    printf "\33]%s;%s\007" $escape "$@"
}

while getopts "bx:h" opt; do
    case $opt in
	b)
	    escape=$esc_boldfont
	    ;;

	x)
	    xlfd=$OPTARG
	    ;;

	h)
	    _usage
	    echo
	    echo '   -b	set boldFont resource'
	    echo '   -x	use raw XLFD instead of XFT'
	    echo '   -h	print this help and exit'
	    echo
	    exit 0
	    ;;
    esac
done

if [ ! -z "$xlfd" ]; then
    _set $xlfd
    exit 0
fi

let x=OPTIND-1
shift $x

font=$1
size=$2
weight=$3

if [ -z "$1" ]; then
    _usage >&2
    exit 64
fi

xft="xft:$font"

if [ ! -z "$size" ]; then
    xft="$xft:pixelsize=$size"
fi

if [ ! -z "$weight" ]; then
    xft="$xft:weight=$weight"
fi

_set $xft
