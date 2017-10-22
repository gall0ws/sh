#!/bin/sh

img=~/pix/lockscrn
cmd=/usr/local/bin/i3lock
cmd_args='-n -f'

(import -window root ${img}.png &&
 convert -colorspace Gray  -blur 1 ${img}{,2}.png) || {
	$cmd $cmd_args -c 000000
	exit 0
}

$cmd $cmd_args -i ${img}2.png
