#!/bin/sh

set -x
umask 027

cmd=/usr/local/bin/i3lock
cmd_args='-n -f -c 000000'
effect='-colorspace Gray -blur 1'

ts=`date +%Y%m%d%H%M%S`
shot=~/pix/ss/${ts}.png
img=~/pix/lockscrn.png

(import -window root $shot && convert $effect $shot $img) || img=/dev/null

$cmd $cmd_args -i $img
