#!/bin/sh

# Save the ALSA state
if [ -x /etc/init.d/alsa-utils ]; then
  /etc/init.d/alsa-utils stop
fi

