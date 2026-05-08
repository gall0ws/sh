#!/bin/sh

type ccat >/dev/null || exit 1

palette="\
       -G String=darkyellow    \
       -G Keyword=fuchsia      \
       -G Comment=faint        \
       -G Type=green           \
       -G Punctuation=faint    \
       -G Plaintext=reset      \
       -G Decimal=white"

ccat $palette --color=always "$1" 2>/dev/null
