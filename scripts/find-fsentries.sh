#!/bin/bash

dir="$1"
pattern="$2"
type=$3
exclusions=()

if [[ "$4" == "--exclude" ]]; then
    exclusions=("${@:5}")
fi

findargs=()

if [[ ${#exclusions[@]} -gt 0 ]]; then
    findargs+=( "(" )

    for i in "${!exclusions[@]}"; do
        if [[ $i -gt 0 ]]; then
            findargs+=( "-o" )
        fi
        findargs+=( "-path" "${exclusions[$i]}" )
    done

    findargs+=( ")" "-prune" "-o" )
fi


find "$dir" "${findargs[@]}" -type $type -ipath "$pattern" -print0 2>/dev/null |
while IFS= read -r -d '' path; do
    numfiles=$(find "$path" -type f -mindepth 1 | wc -l)
    numsubdirs=$(find "$path" -maxdepth 1 -type d -mindepth 1 | wc -l)
    stats=$(stat -c "%W %Y %X %s" "$path")
    isrootowned=$( [[ $(stat -c "%u" "$path") -eq 0 ]] && echo true || echo false)
    hasgit=$( [[ -d $path/.git ]] && echo true || echo false)

    printf '%s\t%s %s %s %s\n' "$path" "$stats" "$isrootowned" "$numfiles" "$numsubdirs $hasgit"
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