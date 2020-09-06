#!/bin/env sh

docked=$(xrandr | grep 'DP1-3 connected')

if [ -n "$docked" ] ; then
    #Docked

    lidfile="/proc/acpi/button/lid/LID/state"
    lidstate=$([ -f "$lidfile" ] && awk '{ print $2 }' "$lidfile")

    case $lidstate in
        closed)
            printf "Docked, lid closed\n"
            ~/.screenlayout/docked_lid_closed.sh
            ;;
        open)
            printf "Docked, lid open\n"
            ~/.screenlayout/docked_lid_open.sh
            ;;
        *)
            printf "Docked, lid state unknown\n"
            ~/.screenlayout/docked_lid_open.sh
            ;;
    esac
else
    # Undocked
    printf "Undocked\n"
    ~/.screenlayout/laptop.sh
fi

# Fix background image
~/.fehbg
