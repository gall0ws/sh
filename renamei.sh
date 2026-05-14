#!/bin/sh
#set -x

## Rename files in a simple format

uconv=/opt/homebrew/bin/uconv
empty=noname
dryrun=
locase=true

cmdname=`basename "$0"`

usage () {
    printf "usage: %s [-d] [-n] file ...\n" $cmdname >&2
    exit 64
}

inode () {
    ls -id "$1" | awk '{print $1}'
}

simplify () {
    trans='Any-Latin; Latin-Ascii'
    if $locase; then
        trans="$trans; Any-Lower"
    fi

    printf "$1" \
        | $uconv -x "$trans"            \
        | $uconv -c -t US-ASCII         \
        | tr '!"#$%&(),\*' _            \
        | tr \' _                       \
        | tr ':;<>?' _                  \
        | tr '\\^`|~' _                 \
        | tr -s '[:space:]'             \
        | tr '[:space:]' _              \
        | tr -d '[:cntrl:]'             \
        | tr -d '[:ideogram:]'          \
        | tr -d '[:phonogram:]'         \
        | tr -d '[:special:]'
}

shifts=0
while :; do
    getopts dn opt $@ || break
    case $opt in
        d)
            dryrun=echo
            let shifts++
            ;;
        n)
            locase=false
            let shifts++
            ;;
        \?)
            usage
    esac
done
shift $shifts

if [ "$1" = "--" ]; then
    shift
fi
if [ $# = 0 ]; then
    usage
fi

for i in `seq $#`; do
    j=$(printf '%s' $`echo $i`)
    file="`eval echo \\"$j\\"`"
    if [ ! -e "$file" ]; then
        printf "%s: error: %s does not exist\n" $cmdname "$file" >&2
        exit 66
    fi

    path=`dirname "$file"`
    old=`basename "$file"`
    new=`simplify "$old"`

    if [ -z "$new" ]; then
        new=$empty
    fi

    if [ "$new" = "$old" ]; then
        continue
    fi

    if [ -e "${path}/${new}" ] && [ `inode "${path}/${new}"` != `inode "${file}"` ]; then
        printf "skipping %s: %s/%s already exists\n" "$file"" $path" "$new"
        continue
    fi

    $dryrun mv -v "${file}" "${path}/${new}"
done
