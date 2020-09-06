#!/bin/sh

focused=$(xprop -root _NET_ACTIVE_WINDOW | awk -F' ' '{print $NF}')

# xprop returns window id # 0x0 when an i3 container is selected rather than a
# window. You get all sorts of weird behavior when you try to float an i3
# container, so just use the default toggle behavior here without trying to be
# clever about the floating window title. Note that if a container is
# made floating, the entire container must be made tiling to return to the
# previous state. Tiling a window inside of a floating container doesn't appear
# to work.
if [ "${focused}" = "0x0" ] ; then
    i3-msg "floating toggle"
else
    if xprop -id "${focused}" I3_FLOATING_WINDOW | grep -q "not found" ; then
        i3-msg "floating enable, border normal 2"
    else
        i3-msg "border pixel 2, floating disable"
    fi
fi
