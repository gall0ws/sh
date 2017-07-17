#!/bin/sh

t=$1

test -z "$1" && {
    t='	' #tab
}

sed "s/^/${t}/"
