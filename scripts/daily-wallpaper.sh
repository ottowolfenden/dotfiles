#!/bin/bash

mode=$1

dir="$HOME/images/wallpapers/clouds/$mode"
n=$(ls "$dir" | wc -l)

hash=$(date +%Y-%m-%d | md5sum | cut -c1-6)
hash=$(echo "scale=5; $((16#$hash)) / 16777215" | bc)
hash=$(echo "$hash * $n" | bc)
hash=$((${hash%.*} + 1))
hash=$(echo "if ($hash < $n) $hash else $n" | bc -l)

echo "$dir"/$(ls "$dir" | head -n $hash  | tail -n 1)