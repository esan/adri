#!/bin/bash
# TODO:  Change above to /bin/sh

test -f /usr/share/acpi-support/key-constants || exit 0

. /etc/default/acpi-support
. /usr/share/acpi-support/power-funcs

getState;

checkStateChanged;

shopt -s nullglob

for x in /proc/acpi/ac_adapter/*; do
    grep -q off-line $x/state

    if [ $? = 0 ] && [ x$1 != xstop ]; then	
	for SCRIPT in /etc/acpi/battery.d/*.sh; do
	    . $SCRIPT
	done
    else
	for SCRIPT in /etc/acpi/ac.d/*.sh; do
	    . $SCRIPT
	done
    fi
done
