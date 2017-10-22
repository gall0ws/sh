#!/bin/sh

cmd='xmessage -file -'

case $# in
	0)
		$cmd
		;;
	*)
		$@ | $cmd
		;;
esac
