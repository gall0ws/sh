#!/bin/sh
set -e

md5=`md5sum "$1" | awk '{print $1}'`
ext=`echo "$1" | awk -F. '{print $NF}'`

scp "$1" aleph0.pw:pix/$md5.$ext
url=https://aleph0.pw/pix/$md5.$ext

if [ ! -z "$DISPLAY" ]; then
	xclip=$(which xclip 2>/dev/null)
	test -x $xclip && echo $url | $xclip -i -selection clipboard
fi

echo $url
