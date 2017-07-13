#!/bin/sh

grep -Rn --color=always -A 5 -B 5 "$@" | less -r
