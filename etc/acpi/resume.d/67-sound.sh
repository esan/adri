#!/bin/sh

# Get sound back
if [ -x /etc/init.d/alsa-utils ]; then
  /etc/init.d/alsa-utils start
fi

