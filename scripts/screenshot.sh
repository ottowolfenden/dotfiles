#!/bin/bash

mode=$1

if pgrep -x "slurp" > /dev/null || pgrep -x "grim" > /dev/null; then
    pkill -x "slurp"
    pkill -x "grim"
else
    while true; do
        filename=$(date +'%Y-%m-%d-%H-%M-%S-%N' | md5sum | cut -c 1-5)
        if [ ! -f ~/images/screenshots/"${filename}.png" ]; then
            break
        fi
        sleep 0.001
    done
    if [[ $mode == "region" ]]; then
        slurp=$(slurp)
        sleep 0.2
        grim -g "$slurp" - | tee ~/images/screenshots/"${filename}.png" | wl-copy
    else
        grim - | tee ~/images/screenshots/"${filename}.png" | wl-copy
    fi
fi