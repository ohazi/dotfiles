#!/bin/sh

focused=$(xprop -root _NET_ACTIVE_WINDOW | awk -F' ' '{print $NF}')
title=$(xprop -id "$focused" _NET_WM_NAME | cut -d '"' -f2)

printf "%s\n" "$title"
