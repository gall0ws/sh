#!/bin/sh

bindir=${1-$HOME/bin}
hash="md5 -q"

scripts="a+.sh a-.sh flood.sh genpw.sh gg.sh monitor.sh pixup.sh q.sh \
            renamei.sh spongemock.sh typespeed_hs_trim.sh videolen.sh "

Darwin="lifecap.sh"
FreeBSD="lock.sh nat.sh urxvt-setfont.sh xm.sh pkg_log.sh"
Linux="docker_cleanup.sh lenovo_scroll.sh lock.sh nat.sh urxvt-setfont.sh xm.sh"
OpenBSD="lock.sh nat.sh urxvt-setfont.sh xm.sh"


test -d $bindir || {
	echo 'invalid dstdir' >&2
	exit 1
}

eval scripts+="$`uname`"

for i in $scripts; do
	dst=${bindir}/`echo $i | sed 's/.sh$//'`
        if [ ! -e "$dst" ] || [ `$hash $dst` != `$hash $i` ]; then
            cp $i $dst || continue
	    chmod +x $dst
	    echo installed $dst
        fi
done
