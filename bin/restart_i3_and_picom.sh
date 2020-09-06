#!/bin/sh

i3-msg restart
killall picom
sleep 0.5
i3-msg "exec --no-startup-id picom -b"
