#!/bin/sh

. /usr/share/acpi-support/state-funcs

ON_VALUE="e"
OFF_VALUE="f"

CHARACTER_POSITION="8"

HOTKEY_VALUE=`echo "$3"| cut -b "$CHARACTER_POSITION"`

if ( isAnyWirelessPoweredOn && [ "$HOTKEY_VALUE" =  "$OFF_VALUE" ] ) || ( ! isAnyWirelessPoweredOn && [ "$HOTKEY_VALUE" =  "$ON_VALUE" ] ) ; then
	toggleAllWirelessStates
fi
