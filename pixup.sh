#!/bin/sh
set -e

md5=`md5sum "$1" | awk '{print $1}'`
ext=`echo "$1" | awk -F. '{print $NF}'`

scp "$1" aleph0.pw:pix/$md5.$ext

echo https://aleph0.pw/pix/$md5.$ext
