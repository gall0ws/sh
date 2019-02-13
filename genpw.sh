#!/bin/sh

flen=${1:-4}
fnum=${2:-4}

let ssz="$flen * $fnum"

openssl rand -base64 $ssz 		\
	| tr -d '\n+/=' 		\
	| sed -r 's/'.{$flen}'/&-/g' 	\
	| cut -d '-' -f -${fnum}
