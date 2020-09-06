#!/bin/bash


# Symbols
up_arrow="<span font_family='Font Awesome'>\uF0D8</span>"
down_arrow="<span font_family='Font Awesome'>\uF0D7</span>"

bat_sm_0='<span font_family="Material Design Icons">\UF008E</span>'
bat_sm_1='<span font_family="Material Design Icons">\UF007A</span>'
bat_sm_2='<span font_family="Material Design Icons">\UF007B</span>'
bat_sm_3='<span font_family="Material Design Icons">\UF007C</span>'
bat_sm_4='<span font_family="Material Design Icons">\UF007D</span>'
bat_sm_5='<span font_family="Material Design Icons">\UF007E</span>'
bat_sm_6='<span font_family="Material Design Icons">\UF007F</span>'
bat_sm_7='<span font_family="Material Design Icons">\UF0080</span>'
bat_sm_8='<span font_family="Material Design Icons">\UF0081</span>'
bat_sm_9='<span font_family="Material Design Icons">\UF0079</span>'

bat_lg_0='<span font_family="Font Awesome">\uF244</span>'
bat_lg_1='<span font_family="Font Awesome">\uF243</span>'
bat_lg_2='<span font_family="Font Awesome">\uF242</span>'
bat_lg_3='<span font_family="Font Awesome">\uF241</span>'
bat_lg_4='<span font_family="Font Awesome">\uF240</span>'

plug='<span font_family="Font Awesome">\uF1E6</span>'




path_ac="/sys/class/power_supply/AC/online"

plugged_in="?"
if [ -f "$path_ac" ]; then
    plugged_in=$(cat /sys/class/power_supply/AC/online)
fi



declare -a path_batteries
path_batteries=("/sys/class/power_supply/BAT0" "/sys/class/power_supply/BAT1")

declare -a energy_now
declare -a energy_full
declare -a power_now
declare -a batteries_fmt

for battery in "${path_batteries[@]}" ; do
    bat_status=$(cat "$battery"/status)
    bat_power_now=$(cat "$battery"/power_now)
    bat_energy_now=$(cat "$battery"/energy_now)
    bat_energy_full=$(cat "$battery"/energy_full)
    bat_charge_level=$(cat "$battery"/capacity)
    # For more precision
    #bat_charge_level=$(echo "scale=1; 100 * $bat_energy_now / $bat_energy_full" | bc)

    fmt=""

    if [ "$bat_charge_level" -le 6 ] ; then
        fmt+="$bat_sm_0"
    elif [ "$bat_charge_level" -le 17 ]; then
        fmt+="$bat_sm_1"
    elif [ "$bat_charge_level" -le 28 ]; then
        fmt+="$bat_sm_2"
    elif [ "$bat_charge_level" -le 39 ]; then
        fmt+="$bat_sm_3"
    elif [ "$bat_charge_level" -le 50 ]; then
        fmt+="$bat_sm_4"
    elif [ "$bat_charge_level" -le 61 ]; then
        fmt+="$bat_sm_5"
    elif [ "$bat_charge_level" -le 72 ]; then
        fmt+="$bat_sm_6"
    elif [ "$bat_charge_level" -le 83 ]; then
        fmt+="$bat_sm_7"
    elif [ "$bat_charge_level" -le 94 ]; then
        fmt+="$bat_sm_8"
    else # -le 100
        fmt+="$bat_sm_9"
    fi

    case $bat_status in
        "Discharging")
            fmt+="$down_arrow "
            ;;
        "Charging")
            fmt+="$up_arrow "
            ;;
        "Unknown")
            fmt+=""
            ;;
        *)
    esac

    fmt+="<span font_features='tnum'>$bat_charge_level</span>%"

    batteries_fmt+=("$fmt")

    # Save these for computing total energy / power numbers
    power_now+=("$bat_power_now")
    energy_now+=("$bat_energy_now")
    energy_full+=("$bat_energy_full")
done


# Add everything up...
energy_now_sum=0
for now in ${energy_now[*]} ; do
    (( energy_now_sum+=now ))
done

energy_full_sum=0
for full in ${energy_full[*]} ; do
    (( energy_full_sum+=full ))
done

power_now_sum=0
for now in ${power_now[*]} ; do
    (( power_now_sum+=now ))
done

# Convert units...
power_now_watts="$(echo "scale=2; $power_now_sum / 1000000" | bc) W"

# Compute totals and times...
charge_level_total="$(echo "scale=0; 100 * $energy_now_sum / $energy_full_sum" | bc)"
if [ "$power_now_sum" -ne 0 ]; then
    time_until_empty=$(echo "3600 * $energy_now_sum / $power_now_sum" | bc | awk '{ print "@"$1 }' | xargs date -u +%-H:%M -d)
    time_until_full=$(echo "3600 * ($energy_full_sum - $energy_now_sum) / $power_now_sum" | bc | awk '{ print "@"$1 }' | xargs date -u +%-H:%M -d)
fi


totals_fmt=""

case $plugged_in in
    0)
        if [ "$charge_level_total" -le 12 ]; then
            totals_fmt+="$bat_lg_0"
        elif [ "$charge_level_total" -le 37 ]; then
            totals_fmt+="$bat_lg_1"
        elif [ "$charge_level_total" -le 62 ]; then
            totals_fmt+="$bat_lg_2"
        elif [ "$charge_level_total" -le 87 ]; then
            totals_fmt+="$bat_lg_3"
        else # -le 100
            totals_fmt+="$bat_lg_4"
        fi

        totals_fmt+=" <span font_features='tnum'>$charge_level_total%"
        if [ -n "$time_until_empty" ]; then
            totals_fmt+=" ($time_until_empty)"
        fi
        totals_fmt+="</span>"
        ;;
    1)
        totals_fmt+="$plug"
        totals_fmt+=" <span font_features='tnum'>$charge_level_total%"
        if [ -n "$time_until_full" ]; then
            totals_fmt+=" ($time_until_full)"
        fi
        totals_fmt+="</span>"
        ;;
    *)
        totals_fmt+="?"
        ;;
esac

printf "%b  " "$totals_fmt"

for fmt in "${batteries_fmt[@]}" ; do
    printf "[%b]" "$fmt"
done

if [ "$power_now_watts" != "" ]; then
    printf "  (%s)" "<span font_features='tnum'>$power_now_watts</span>"
fi

printf "\n"
