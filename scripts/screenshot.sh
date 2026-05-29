#!/bin/bash

if pgrep -x "slurp" > /dev/null || pgrep -x "grim" > /dev/null; then
    pkill -x "slurp"
    pkill -x "grim"
else
    while true; do
        FILENAME=$(date +'%Y-%m-%d-%H-%M-%S-%N' | md5sum | cut -c 1-5)
        if [ ! -f ~/screenshots/"${FILENAME}.png" ]; then
            break
        fi
        sleep 0.001
    done
    grim -g "$(slurp -w 0)" - | tee ~/screenshots/"${FILENAME}.png" | wl-copy
fi