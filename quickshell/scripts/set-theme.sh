#!/bin/bash

MODE="$1"

if [ "$MODE" = "dark" ]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
    sed -i 's/gtk-theme-name=.*/gtk-theme-name=Adwaita-dark/' ~/.config/gtk-3.0/settings.ini
    sed -i 's/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=true/' ~/.config/gtk-3.0/settings.ini
    sed -i "s/color_scheme_path=.*/color_scheme_path=\/usr\/share\/qt6ct\/colors\/darker.conf/" ~/.config/qt6ct/qt6ct.conf
    thunar -q 2>/dev/null
elif [ "$MODE" = "light" ]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
    sed -i 's/gtk-theme-name=.*/gtk-theme-name=Adwaita/' ~/.config/gtk-3.0/settings.ini
    sed -i 's/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=false/' ~/.config/gtk-3.0/settings.ini
    sed -i "s/color_scheme_path=.*/color_scheme_path=\/usr\/share\/qt6ct\/colors\/simple.conf/" ~/.config/qt6ct/qt6ct.conf
    thunar -q 2>/dev/null
else
    exit 1
fi