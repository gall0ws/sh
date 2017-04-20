#!/bin/sh

cmd="$1"
if=${2:-wlan0}

case $cmd in
start)
	kldstat -q -m ipdivert || kldload ipdivert || exit 1
	sysctl net.inet.ip.forwarding=1

	natd -interface ${if}

	/sbin/ipfw -f flush
	/sbin/ipfw add divert natd all from any to any via ${if}
	/sbin/ipfw add pass all from any to any
	;;

stop)
	sysctl net.inet.ip.forwarding=0

	kill $(cat /var/run/natd.pid) || exit 1

	/sbin/ipfw -f flush
	/sbin/ipfw add allow ip from any to any
	;;

*)
	echo "usage: $0 start|stop [if]" >&2
	;;
esac

