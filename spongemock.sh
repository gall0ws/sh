#!/bin/sh
## https://knowyourmeme.com/memes/mocking-spongebob


spongemock() {
	awk '{
		split($0, s, "")
		for (i=1 && j=0; i<=length($0); i++) {
			if (s[i] ~ /[[:alpha:]]/) j++
			printf("%s", j % 2 ? toupper(s[i]) : tolower(s[i]))
		}
	}'
	echo
}


if [ -z "$1" ]; then
	spongemock
else
	echo $@ | spongemock
fi
