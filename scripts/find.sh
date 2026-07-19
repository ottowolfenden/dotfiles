#!/bin/bash

dir="$1"
text="$2"
type=$3
max=$4
exclusions=()

if [[ "$5" == "--exclude" ]]; then
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
format=(-printf "%A@ %p\0")
sort() { 
    if [[ $1 == -accessed ]]; then
        command sort -znr 
    elif [[ $1 == -depth ]]; then
        awk 'BEGIN { RS="\0"; ORS="\0" } {
            path = $2;
            depth = gsub(/\//, "", path);
            print depth, $2 
        }' | command sort -zns
    fi
}
cut() { command cut -zd' ' -f1-; }

(
    find "${filters[@]}" -ipath "$text*" "${format[@]}" | sort -accessed | sort -depth | cut
    find "${filters[@]}" -iname "$text" ! -ipath "$text*" "${format[@]}" | sort -accessed | cut
    find "${filters[@]}" -iname "$text*" ! -iname "$text" "${format[@]}" | sort -accessed | cut
    find "${filters[@]}" -iname "*$text*" ! -iname "$text*" "${format[@]}" | sort -accessed | cut
    find "${filters[@]}" -ipath "*$text*" ! -iname "*$text*" "${format[@]}" | sort -accessed | cut
) 2>/dev/null |
awk -v max="$max" 'BEGIN { RS="\0"; ORS="\0" } NR > max { exit } { print }' |
while IFS=" " read -r -d '' bytesize path; do
    if [[ $type == d ]]; then
        [[ -d $path/.git ]] && hasgit=true || hasgit=false
    fi
    printf '%s\t%s\n' "$path" "$hasgit"
done |
jq -R '
    split("\t") as $parts
    | $parts[1] | split(" ") as $stats
    | {
        path: $parts[0],
        hasGit: $stats[0] | try toboolean catch null,
    }
' | jq -s '.'