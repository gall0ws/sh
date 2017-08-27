#!/bin/sh

portsroot=/usr/ports
portname=$1

out=`whereis $portname | awk -F ${portsroot}/ '{print $2}'`
test -z "$out" && exit 1

echo $out

