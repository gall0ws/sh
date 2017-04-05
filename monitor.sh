#!/bin/sh

pause=$1
shift
cmd=$@

while true; do
	clear
	$cmd
	sleep $pause
done
