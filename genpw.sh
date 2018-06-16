#!/bin/sh

openssl rand -base64 50 \
	| tr -d '\n+/=' \
	| sed 's/.../&-/g' \
	| cut -d '-' -f -${1:-4}
