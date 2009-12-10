#!/bin/sh

test -f /usr/share/acpi-support/key-constants || exit 0

# default span value
SPAN=1

# check power state

STATE=`grep -c off-line /proc/acpi/ac_adapter/*/state`
if [ "x$STATE" = "x0" ]
   then
   INTERFACE="ac_brightness"
else
   INTERFACE="dc_brightness"
fi

# get brightness parameters

BRIGHTNESS=$(( `cat /proc/acpi/pcc/$INTERFACE` ))
MAXBRIGHT=$(( `cat /proc/acpi/pcc/"$INTERFACE"_max` ))
MINBRIGHT=$(( `cat /proc/acpi/pcc/"$INTERFACE"_min` ))

# adjust span so that there are 10 brightness increments

WIDTH=$(( $MAXBRIGHT - $MINBRIGHT ))
SPAN=$(( $WIDTH / 10 ))

if [ "x$1" = "xdown" ]; then
   LIMIT=$(( $MINBRIGHT + $SPAN ))
   if [ $BRIGHTNESS -gt $LIMIT ]; then
      BRIGHTNESS=$(( $BRIGHTNESS - $SPAN ))

   else
      BRIGHTNESS=$(( $MINBRIGHT ))
   fi
   echo $BRIGHTNESS > /proc/acpi/pcc/$INTERFACE
elif [ "x$1" = "xup" ]; then
   LIMIT=$(( $MAXBRIGHT - $SPAN ))
   if [ $BRIGHTNESS -lt $LIMIT ]; then
      BRIGHTNESS=$(( $BRIGHTNESS + $SPAN ))
   else
      BRIGHTNESS=$(( $MAXBRIGHT ))
   fi
   echo $BRIGHTNESS > /proc/acpi/pcc/$INTERFACE
else
   echo >&2 Unknown argument $1
fi
