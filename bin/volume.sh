#!/bin/sh

mute='<span font_family="Font Awesome 5 Free Solid">\uf6a9</span>'
vol_0='<span font_family="Font Awesome 5 Free Solid">\uf026</span>'
vol_1='<span font_family="Font Awesome 5 Free Solid">\uf027</span>'
vol_2='<span font_family="Font Awesome 5 Free Solid">\uf028</span>'

#sinks=$(pactl list sinks)

#is_sink_muted=$(printf "%s" "$sinks" | grep Mute | awk '{ print $2 }')
is_muted=$(pamixer --get-mute)

#sink_volume_left_abs=$(printf "%s" "$sinks" | grep Volume | head -1 | awk '{ print $3 }')
#sink_volume_right_abs=$(printf "%s" "$sinks" | grep Volume | head -1 | awk '{ print $10 }')
#sink_volume_base_abs=$(printf "%s" "$sinks" | grep "Base Volume" | awk '{ print $3 }')

#sink_volume_left_percent=$(printf "%s" "$sinks" | grep Volume | head -1 | awk '{ print $5 }')
#sink_volume_right_percent=$(printf "%s" "$sinks" | grep Volume | head -1 | awk '{ print $12 }')
volume=$(pamixer --get-volume)

case $is_muted in
    true)
        printf "%b " "$mute"
        ;;
    false)
        if [ "$volume" -lt 33 ] ; then
            printf "%b " "$vol_0"
        elif [ "$volume" -lt 66 ] ; then
            printf "%b " "$vol_1"
        else
            printf "%b " "$vol_2"
        fi
        ;;
esac

printf " %s" "<span font_features=\"tnum\">$volume%</span>"

#if [ "$sink_volume_left_abs" != "$sink_volume_right_abs" ] ; then
#    printf "!"
#fi

printf "\n"
