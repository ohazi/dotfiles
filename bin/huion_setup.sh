#!/bin/sh

# Default (full drawing area)
#xsetwacom set "HUION Huion tablet_Q620M stylus" "Area" "0 0 53340 33020"

# 16:9 aspect ratio (bottom region clipped)
#xsetwacom set "HUION Huion tablet_Q620M stylus" "Area" "0 0 53340 30004"

# Get all matching devices
# (appears twice when plugged in via USB and wireless adapter)
IDS=$(xsetwacom -- list devices | grep "type: STYLUS" | awk -F'\t' '{ print $2 }' | awk '{ print $2 }')

for id in $IDS ; do
    xsetwacom set "$id" "Area" "0 0 53340 30004"
done

