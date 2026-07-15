#!/bin/bash

dir="$1"
text="$2"
type=$3
max=$4
appendexclusions=$5
exclusions=()

if [[ "$6" == "--exclude" ]]; then
    exclusions=("${@:5}")
fi

exclargs=()

if [[ ${#exclusions[@]} -gt 0 ]]; then
    exclargs+=( "(" )
    for i in "${!exclusions[@]}"; do
        if [[ $i -gt 0 ]]; then
            exclargs+=( "-o" )
        fi
        exclargs+=( "-path" "${exclusions[$i]}" )
    done
    exclargs+=( ")" "-prune" "-o" )
fi

filters=( "$dir" "${exclargs[@]}" -type $type )
format=(-printf "%A@ %s %p\0")
sorta() { sort -znr | cut -zd' ' -f2-; }

(
    find "${filters[@]}" -iname "$text" "${format[@]}" | sorta
    find "${filters[@]}" -iname "$text*" ! -iname "$text" "${format[@]}" | sorta
    find "${filters[@]}" -iname "*$text*" ! -iname "$text*" "${format[@]}" | sorta
    find "${filters[@]}" -ipath "*$text*" ! -iname "*$text*" "${format[@]}" | sorta
    if [[ $appendexclusions == --appendexclusions ]]; then
        find "$dir" -type $type -iname "$text" "${format[@]}" | sorta
        find "$dir" -type $type -iname "$text*" ! -iname "$text" "${format[@]}" | sorta
        find "$dir" -type $type -iname "*$text*" ! -iname "$text*" "${format[@]}" | sorta
        find "$dir" -type $type -ipath "*$text*" ! -iname "*$text*" "${format[@]}" | sorta
    fi
) 2>/dev/null |
awk -v max="$max" 'BEGIN {RS="\0"; ORS="\0"} NR > max {exit} {print}' |
while IFS=" " read -r -d '' bytesize path; do
    if [[ $type == d ]]; then
        shopt -s nullglob; files=( "$path"/* ); shopt -u nullglob
        numitems=${#files[@]};
        [[ -d $path/.git ]] && hasgit=true || hasgit=false
        bytesize=""
    fi
    printf '%s\t%s %s %s\n' "$path" "$numitems" "$hasgit" "$bytesize"
done |
jq -R '
    split("\t") as $parts
    | $parts[1] | split(" ") as $stats
    | {
        path: $parts[0],
        numItems: $stats[0] | try tonumber catch null,
        hasGit: $stats[1] | try toboolean catch null,
        byteSize: $stats[2] | try tonumber catch null
    }
' | jq -s '.'