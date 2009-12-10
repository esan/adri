#!/bin/bash
# TODO:  Above should be /bin/sh

test -f /usr/share/acpi-support/state-funcs || exit 0

. /etc/default/acpi-support
. /usr/share/acpi-support/power-funcs
. /usr/share/acpi-support/policy-funcs

if [ x$ACPI_HIBERNATE != xtrue ] && [ x$1 != xforce ]; then
  exit;
fi

# Unset video posting - it's not needed for suspend to disk
unset POST_VIDEO
unset USE_DPMS

. /etc/acpi/prepare.sh

#if [ x$LOCK_SCREEN = xtrue ]; then
#    for x in /tmp/.X11-unix/*; do
#	displaynum=`echo $x | sed s#/tmp/.X11-unix/X##`
#	getXuser;
#	if [ x"$XAUTHORITY" != x"" ]; then
#	    export DISPLAY=":$displaynum"
#	    . /usr/share/acpi-support/screenblank
#	fi
#    done
#fi

echo -n $HIBERNATE_MODE >/sys/power/disk

if [ -x /sbin/s2disk ]; then
    DEVICE="/dev/disk/by-uuid/`awk -F= '{print $3}' </etc/initramfs-tools/conf.d/resume`"
    if [ -f /etc/usplash.conf ]; then
	. /etc/usplash.conf
	/sbin/s2disk -x "$xres" -y "$yres" $DEVICE
    else
	/sbin/s2disk $DEVICE
    fi
else
    echo -n "disk" >/sys/power/state
fi

$LAPTOP_MODE stop

. /etc/acpi/resume.sh
