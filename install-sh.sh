#!/bin/sh

bindir=${1-$HOME/bin}
hash="md5 -q"

bins="a+.sh a-.sh flood.sh genpw.sh gg.sh monitor.sh pixup.sh q.sh spongemock.sh \
           typespeed_hs_trim.sh "

Darwin="lifecap.sh"
FreeBSD="lock.sh nat.sh urxvt-setfont.sh xm.sh pkg_log.sh"
Linux="docker_cleanup.sh lenovo_scroll.sh lock.sh nat.sh urxvt-setfont.sh xm.sh"
OpenBSD="lock.sh nat.sh urxvt-setfont.sh xm.sh"


test -d $bindir || {
	echo 'invalid dstdir' >&2
	exit 1
}

eval bins+="$`uname`"

for i in $bins; do
	dst=${bindir}/`echo $i | sed 's/.sh$//'`
        if [ ! -e "$dst" ] || [ `$hash $dst` != `$hash $i` ]; then
            cp $i $dst
	    chmod +x $dst
	    echo installed $dst
        fi
done
