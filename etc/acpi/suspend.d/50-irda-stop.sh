#!/bin/sh

# Stop IRDA if it's running
if [ -f /var/run/irattach.pid ]; then
    /etc/init.d/irda-utils stop
    killall -9 irattach
fi

