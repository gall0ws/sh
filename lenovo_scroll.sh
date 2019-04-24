#!/bin/sh
#
# Improve scrolling for IBM 3-Button Scrollpoint under X11 with evdev.
#
# udev rule:
#	SUBSYSTEM=="usb", ATTR{idVendor}=="04b3", ATTR{idProduct}=="3108", RUN="/lib/udev/lenovo_scroll"
#
if [ -z $DISPLAY ]; then
	# Common scenario.
	export DISPLAY=:0.0
fi

eval `xinput list | awk '$4 == "04b3:3108" {print $5}'`
if [ -z "$id" ]; then
	echo "$0: device not found" >&2
	exit 1
fi
xinput set-prop $id "Evdev Scrolling Distance" 20 1 1
