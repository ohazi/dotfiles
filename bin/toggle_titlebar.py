#!/usr/bin/env python3

from i3ipc import Connection, Event

i3 = Connection()

focused = i3.get_tree().find_focused()

if focused.border == "normal":
    i3.command("border pixel 2")
else:
    i3.command("border normal 2")
