#!/bin/bash

if pgrep -x "slurp" > /dev/null || pgrep -x "grim" > /dev/null; then
    pkill -x "slurp"
    pkill -x "grim"
else
    grim -g "$(slurp)" - | tee ~/screenshots/"$(date +'%Y-%m-%d %H:%M:%S').png" | wl-copy
fi