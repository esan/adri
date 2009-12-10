#!/bin/sh
[ -f /usr/share/acpi-support/state-funcs ] || exit 0 

# get the current state of the touchpad
TPSTATUS=`synclient -l | awk '/TouchpadOff/ {print $3}'`

# if getting the status failed, exit
test -z $TPSTATUS && exit 1

if [ $TPSTATUS = 0 ]; then
   synclient TouchpadOff=1
else
   synclient TouchpadOff=0
fi

