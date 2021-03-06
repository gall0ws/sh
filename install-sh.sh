#!/bin/sh

srcdir=${1-$HOME/src/sh}
bindir=${2-$HOME/bin}

test -d $srcdir || {
	echo 'invalid srcdir' >&2 
	exit 1
}

for i in `ls ${srcdir}/*.sh`; do
	dst=${bindir}/$(basename $i | sed 's/.sh$//')
	cat $i > $dst
	chmod +x $dst
	echo installed $dst
done
