#!/bin/sh

svn=/usr/local/bin/svn
flags=""
portsroot=/usr/ports
limit=1

_err() {
	echo $@ >&2
}

_usage() {
	_err $0 [-dv] [-l limit] pkg-name
	exit 64
}

args=$(getopt dl:v $*)

test $? || _usage

set -- $args
while :; do
	case "$1" in
	-d)
		flags="${flags} --diff"
		shift
		;;
	-l)
		limit=$2
		shift; shift
		;;
	-v)
		flags="${flags} -v"
		shift
		;;
	--)
		shift 
		break
		;;
	esac
done

flags="${flags} -l $limit"

port=$1
test -z "$port" && _usage

echo $port | grep -q / || {
	port=$(whereis $port | awk -F ${portsroot}/ '{print $2}')
}

origin=$(dirname $port)
name=$(basename $port)

test ! -d ${portsroot}/${origin}/${name} && {
	_err port \`$port\' does not exists
	exit 1
}

$svn log $flags svn://svn.freebsd.org/ports/head/${origin}/${name}
