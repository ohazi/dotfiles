#!/bin/sh

killall xss-lock
xss-lock --transfer-sleep-lock -- slock
