#!/bin/sh

pause=$1
shift
cmd=$@

while true; do
	out=$($cmd)
	clear
	echo "$out"
	sleep $pause
done
