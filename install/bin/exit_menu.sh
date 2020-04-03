#!/usr/bin/env bash

declare -a menu
declare -A menu_cmds

menu=(
    "Cancel"
    "Lock Session"
    "Exit i3"
    "Suspend"
    "Hibernate"
    "Hybrid Sleep (Hibernate then Suspend)"
    "Suspend then Hibernate (Suspend; Hibernate after delay)"
    "Reboot"
    "Shutdown"
)

menu_cmds["Cancel"]=""
menu_cmds["Lock"]="loginctl lock-session"
menu_cmds["Exit"]="i3-msg exit"
menu_cmds["Suspend"]="systemctl suspend"
menu_cmds["Hibernate"]="systemctl hibernate"
menu_cmds["Hybrid"]="systemctl hybrid-sleep"
menu_cmds["Suspend"]="systemctl suspend-then-hibernate"
menu_cmds["Reboot"]="systemctl reboot"
menu_cmds["Shutdown"]="systemctl poweroff"

#declare -p menu
#declare -p menu_cmds

menu_full=""
for menu_item in "${menu[@]}"
do
    menu_full="$menu_full${menu_item}\n"
done
#echo -ne $menu_full

selection=$(echo -ne "$menu_full" | rofi -dmenu -i | awk '{ print $1 }')
#echo $selection

if [ "$selection" != "" ] ; then
    command=${menu_cmds[$selection]}
    $command
fi
