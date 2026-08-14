#!/bin/bash

BC='platform::kbd_backlight';
current=$(brightnessctl --device=$BC get)

if [[ $1 == "on" || $current == 0 ]]; then
    brightnessctl --device=$BC set 25%
elif [[ $1 == "off" || $current -gt 0 ]]; then
    brightnessctl --device=$BC set 0%
fi