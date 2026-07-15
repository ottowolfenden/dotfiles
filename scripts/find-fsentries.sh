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

findargs=( "$dir" "${exclargs[@]}" -type $type )

(
    find "${findargs[@]}" -iname "$text*" -printf "%A@ %p\0" | sort -znr | cut -zd' ' -f2-
    find "${findargs[@]}" -iname "*$text*" ! -iname "$text*" -printf "%A@ %p\0" | sort -znr | cut -zd' ' -f2-
    find "${findargs[@]}" -ipath "*$text*" ! -iname "*$text*" -printf "%A@ %p\0" | sort -znr | cut -zd' ' -f2-
    if [[ $appendexclusions == --appendexclusions ]]; then
        find "$dir" -type $type -iname "$text*" -printf "%A@ %p\0" | sort -znr | cut -zd' ' -f2-
        find "$dir" -type $type -iname "*$text*" ! -iname "$text*" -printf "%A@ %p\0" | sort -znr | cut -zd' ' -f2-
        find "$dir" -type $type -ipath "*$text*" ! -iname "*$text*" -printf "%A@ %p\0" | sort -znr | cut -zd' ' -f2-
    fi
) 2>/dev/null |
awk -v max="$max" 'BEGIN {RS="\0"; ORS="\0"} NR > max {exit} {print}' |
while IFS= read -r -d '' path; do
    numfiles=$(find "$path" -type f -mindepth 1 | wc -l)
    numsubdirs=$(find "$path" -maxdepth 1 -type d -mindepth 1 | wc -l)
    stats=$(stat -c "%W %Y %X %s" "$path")
    isrootowned=$( [[ $(stat -c "%u" "$path") -eq 0 ]] && echo true || echo false)
    hasgit=$( [[ -d $path/.git ]] && echo true || echo false)

    printf '%s\t%s %s %s %s %s\n' "$path" "$stats" "$isrootowned" "$numfiles" "$numsubdirs" "$hasgit"
done |
jq -R '
    split("\t") as $parts
    | $parts[1] | split(" ") as $stats
    | {
        path: $parts[0],
        created: $stats[0] | tonumber,
        modified: $stats[1] | tonumber,
        accessed: $stats[2] | tonumber,
        byteSize: $stats[3] | tonumber,
        isRootOwned: $stats[4] | toboolean,
        numFiles: $stats[5] | tonumber,
        numSubdirs: $stats[6] | tonumber,
        hasGit: $stats[7] | toboolean
    }
' | jq -s '.'