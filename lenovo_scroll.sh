#!/bin/sh

eval `xinput list | awk '$4 == "04b3:3108" {print $5}'`
if [ -z "$id" ]; then
    echo 'device not found' >&2
    exit 1
fi
xinput set-prop $id "Evdev Scrolling Distance" 20 1 1
