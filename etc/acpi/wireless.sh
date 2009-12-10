#!/bin/sh

test -f /usr/share/acpi-support/key-constants || exit 0

# Find and toggle wireless device states

. /usr/share/acpi-support/state-funcs

toggleAllWirelessStates;
