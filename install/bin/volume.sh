#!/bin/sh

mute='<span font_family="Font Awesome 5 Free Solid">\uf6a9</span>'
vol_0='<span font_family="Font Awesome 5 Free Solid">\uf026</span>'
vol_1='<span font_family="Font Awesome 5 Free Solid">\uf027</span>'
vol_2='<span font_family="Font Awesome 5 Free Solid">\uf028</span>'

sinks=$(pactl list sinks)

is_sink_muted=$(printf "%s" "$sinks" | grep Mute | awk '{ print $2 }')

sink_volume_left_abs=$(printf "%s" "$sinks" | grep Volume | head -1 | awk '{ print $3 }')
sink_volume_right_abs=$(printf "%s" "$sinks" | grep Volume | head -1 | awk '{ print $10 }')
sink_volume_base_abs=$(printf "%s" "$sinks" | grep "Base Volume" | awk '{ print $3 }')

sink_volume_left_percent=$(printf "%s" "$sinks" | grep Volume | head -1 | awk '{ print $5 }')
#sink_volume_right_percent=$(printf "%s" "$sinks" | grep Volume | head -1 | awk '{ print $12 }')

case $is_sink_muted in
    yes)
        printf "%b " "$mute"
        ;;
    no)
        if [ $((100 * sink_volume_left_abs / sink_volume_base_abs)) -lt 33 ] ; then
            printf "%b " "$vol_0"
        elif [ $((100 * sink_volume_left_abs / sink_volume_base_abs)) -lt 66 ] ; then
            printf "%b " "$vol_1"
        else
            printf "%b " "$vol_2"
        fi
        ;;
esac

printf " %s" "<span font_features=\"tnum\">$sink_volume_left_percent</span>"

if [ "$sink_volume_left_abs" != "$sink_volume_right_abs" ] ; then
    printf "!"
fi

printf "\n"
