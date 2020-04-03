#!/bin/sh

date=$(date '+%a, %b %-d   %-I:%M:%S %p')

# tnum: enable tabular (monospaced) figures
# zero: alternate zero to differentiate from O
printf "<span font_features=\"tnum\">%s</span>\n" "$date"
