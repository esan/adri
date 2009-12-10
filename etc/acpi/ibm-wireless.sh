#!/bin/sh

test -f /usr/share/acpi-support/state-funcs || exit 0

# Find and toggle wireless of bluetooth devices on ThinkPads

. /usr/share/acpi-support/state-funcs

BLUETOOTH=/proc/acpi/ibm/bluetooth

if [ -r $BLUETOOTH ]; then
    grep -q disabled $BLUETOOTH
    bluetooth_state=$?
fi

# Note that this always alters the state of the wireless!
toggleAllWirelessStates;

# Sequence is Both on, Bluetooth only, Wireless only, Both off
if ! isAnyWirelessPoweredOn; then
    # Wireless was turned off
    if [ -w $BLUETOOTH ]; then
        if [ "$bluetooth_state" = 0 ]; then
            echo enable > $BLUETOOTH;
        else
            echo disable > $BLUETOOTH
        fi
    fi
fi
