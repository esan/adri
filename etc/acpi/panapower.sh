#!/bin/sh

test -f /usr/share/acpi-support/key-constants || exit 0

. /usr/share/acpi-support/power-funcs

grep -q off-line /proc/acpi/ac_adapter/*/state

if [ $? = 0 ]
        then
	INTERFACE="dc_brightness"
else
	INTERFACE="ac_brightness"
fi

BRIGHTNESS=$(( `cat /proc/acpi/pcc/$INTERFACE` + 0 ))
echo $BRIGHTNESS > /proc/acpi/pcc/$INTERFACE
