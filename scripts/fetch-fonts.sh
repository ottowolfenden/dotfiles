#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"/.. || exit

fonts=(material-symbols-extended-24px.ttf material-symbols-extended-24px-fill.ttf)
api="https://raw.githubusercontent.com/ottowolfenden/material-symbols-extended/refs/heads/main/fonts"

for font in "${fonts[@]}"; do
    (curl -fsSL "$api/$font" -o "quickshell/fonts/$font" && printf 'downloaded %s\n' "$font") &
done

wait