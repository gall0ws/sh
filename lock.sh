#!/bin/sh

PATH=/usr/bin:/usr/local/bin

set -x
umask 027

shot=~/pix/lockscrn_orig.png
img=~/pix/lockscrn.png
fx='-colorspace Gray -blur 1'

trap 'rm $shot $img 2>/dev/null' 0 1 2 3 15

(import -window root $shot && convert $fx $shot $img) || img=/dev/null
i3lock -n -f -c 000000 -i $img
