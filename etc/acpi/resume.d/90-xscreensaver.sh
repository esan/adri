#!/bin/sh

# now, we should poke xscreensaver so you get a dialog
if pidof xscreensaver > /dev/null; then 
    for x in /tmp/.X11-unix/*; do
	displaynum=`echo $x | sed s#/tmp/.X11-unix/X##`
	getXuser;
	if [ x"$XAUTHORITY" != x"" ]; then
	    export DISPLAY=":$displaynum"
	    su $user -c "(xscreensaver-command -deactivate)"
	fi
    done
fi
