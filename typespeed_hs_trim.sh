#!/bin/sh
#set -x

## Limits typespeed's highscores to one page.

pfx=~/.typespeed
tmpf=`mktemp`

cat "$pfx/score" | sort -rn | awk '
BEGIN {
        # a page contains 17 entries.
        max = 17
}
{
        if (cnt[$5] == "") {
                cnt[$5] = 1;
                print;
        } else if (cnt[$5] < max) {
                cnt[$5]++
                print
        }
}' > $tmpf

if [ $? != 0 ]; then
    rm $tmpf
    exit 1
fi

if [ `cat $tmpf | wc -l` = `cat "$pfx/score" | wc -l` ]; then
    echo "nothing to do"
    rm $tmpf
    exit 0
fi

cp -v "$pfx/score" "$pfx/score~"
mv -v $tmpf "$pfx/score"

type gawk >& /dev/null && \
        sort -rn  "$pfx/score~" | \
        diff -u - "$pfx/score"  | \
        gawk '/^-[0-9]/ {
                 printf("removed %d by %s (%s)\t %s\n",
                   substr($1, 2), $4, $5, strftime("%d %B %H:%M", $8))
             }'
