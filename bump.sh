#!/bin/sh

_red() {
    echo -en '\e[31m'$@'\e[0m'
}

_green() {
    echo -en '\e[32m'$@'\e[0m'
}

_err() {
    echo $@ >&2
}

get_version() {
    grep -m1 "${tagopen}.*${tagclosed}" $1		\
	|sed -e "s/${tagopen}\(.*\)${tagclosed}/\1/"	\
	|tr -d '[:space:]'
}

get_poms() {
    du -a $1 | awk '/pom.xml/{print $2}'
}

ask_confirm() {
    echo performing version bump from $(_red $curversion) to $(_green $newversion)
    echo
    echo files affected:
    for f in $poms; do
	echo "	$f"
    done
    echo
    echo -n 'continue? [y/N] '
    read a
    test $a != 'y' && {
	echo aborted
	exit 0
    }
}

## entry point
tagopen='<version>'
tagclosed='<\/version>'
usage="usage: $cmd [-nF] [-d DIR] NEW_VERSION"

cmd=`basename $0`
dir=
force=

while getopts "Fd:h" opt; do
    case $opt in
	F)
	    force=yes
	    ;;
	d)
	    dir=$OPTARG
	    ;;
	h|\?)
	    echo $usage
	    exit 64
	    ;;
    esac
done

let x=OPTIND-1
shift $x
newversion=$1

test -z "$newversion" && {
    _err $usage
    exit 64
}

poms=`get_poms $dir`
curversion=`get_version $poms`

test $curversion == $newversion && {
    echo Current version is equal to the given new version. Nothing to do.
    exit 0
}

test -z "$force" && ask_confirm

for f in $poms; do
    cp $f ${f}.bkp
    sed "s/${curversion}/${newversion}/" < ${f}.bkp > $f
    rm -f ${f}.bkp
done
