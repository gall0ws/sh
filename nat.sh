#!/bin/sh

#set -x

cmd="$1"
iif=${2:-eth0}     ## internal interface 
eif=${3:-wlan0}    ## external interface (e.g. the one connected to the internet)

ipfw=/sbin/ipfw
iptables=/usr/sbin/iptables

freebsd_start() {
    kldstat -q -m ipdivert || kldload ipdivert || exit 1
    sysctl net.inet.ip.forwarding=1

    natd -interface ${eif}

    ${ipfw} -f flush
    ${ipfw} add divert natd all from any to any via ${eif}
    ${ipfw} add pass all from any to any
}

freebsd_stop() {
    sysctl net.inet.ip.forwarding=0

    kill $(cat /var/run/natd.pid) || exit 1

    ${ipfw} -f flush
    ${ipfw} add allow ip from any to any
}

linux_start() {
    echo 1  >/proc/sys/net/ipv4/ip_forward
    ${iptables} -t nat -A POSTROUTING -o ${eif} -j MASQUERADE
    ${iptables} -A FORWARD -i ${eif} -o ${iif} -m state --state RELATED,ESTABLISHED -j ACCEPT
    ${iptables} -A FORWARD -i ${iif} -o ${eif} -j ACCEPT
}

linux_stop() {
    echo 0  >/proc/sys/net/ipv4/ip_forward
    ${iptables} -F FORWARD
    ${iptables} -t nat -F POSTROUTING
}

sys=`uname -s | tr [:upper:] [:lower:]`

case $cmd in
    start)
	${sys}_start
	;;

    stop)
	${sys}_stop
	;;
    *)
	echo "usage: $0 start|stop [EIFACE [IIFACE]]" >&2
	;;
esac
