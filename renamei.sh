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


# Hack: parse arguments in a subshell in order to avoid losing metachars in $*
# See BUGS in getopt(1)
`{
shifts=0
args=$(getopt dn $*)
if [ $? != 0 ]; then
    usage
    exit 64
fi

set -- $args
while true; do
    case "$1" in
        -d)
            dryrun=echo
            shift
            let shifts++
            ;;
        -n)
            locase=false
            shift
            let shifts++
            ;;
        --)
            shift
            break
            ;;
    esac
done

# sets variables in the parent shell
echo export dryrun=$dryrun locase=$locase shifts=$shifts
}`

# consume parsed arguments
while [ $shifts -gt 0 ]; do
    shift
    ((shifts--))
done

if [ $# = 0 ]; then
    usage
    exit 64
fi

for i in `seq $#`; do
    file="`eval echo "\\${${i}}"`"
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
    fi

    $dryrun mv -v "${file}" "${path}/${new}"
done
