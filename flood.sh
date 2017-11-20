#!/bin/sh

tm=$1
shift
cmd="$@"

usage() {
	echo "usage: $0 INTERVAL CMD" >&2
	exit 64
}

spawn() {
	$@ >/dev/null 2>&1

	case $? in
		0)
			echo -n .
			;;
		126)
			echo -n @
			;;
		127)
			echo -n @
			;;
		*)
			echo -n \*
			;;
	esac
}

if [[ -z "$tm" || -z "$cmd" ]]; then
	usage
fi

while :; do
	sleep $tm 2>/dev/null || usage
	spawn $cmd &
done
