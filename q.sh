#!/bin/sh

sign=\'
args=`getopt s: $*`

set -- $args
while :; do
	case "$1" in
	-s)
		sign=$2
		shift; shift;
		;;
	--)
		shift; break;
		;;
	esac
done

echo ${sign}${@}${sign}
