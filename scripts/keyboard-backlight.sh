#!/bin/bash

BC='platform::kbd_backlight';
[ $(brightnessctl --device=$BC get) -eq 0 ] && brightnessctl --device=$BC set 25% || brightnessctl --device=$BC set 0%
