#!/bin/sh
# Paul Sladen, 2006-03-28
# Save the 'dmidecode' data while we are running as root, so
# that it can used later in '/usr/share/acpi-support/device-funcs'
# which can be sourced by 'pmi' running as a user.
#
# Lets assume that this isn't particularly priviliged information...

dmidecode --string system-manufacturer|sed -e 's/ *$//' > /var/lib/acpi-support/system-manufacturer
dmidecode --string system-product-name|sed -e 's/ *$//' > /var/lib/acpi-support/system-product-name
dmidecode --string system-version     |sed -e 's/ *$//' > /var/lib/acpi-support/system-version
dmidecode --string bios-version       |sed -e 's/ *$//' > /var/lib/acpi-support/bios-version
