#!/bin/bash

dir="$1"
pattern="$2"
type=$3
opt=$4

if [[ $type == -f ]]; then
    if [[ $opt == --includehidden ]]; then
        find "$dir" -type f -iname "$pattern" -print0 2>/dev/null
    else
        find "$dir" -name ".*" -prune -o \
            -type f -iname "$pattern" -print0 2>/dev/null
    fi
else
    if [[ $opt == --includehidden ]]; then
        find "$dir" -type d -iname "$pattern" -print0 2>/dev/null
    else
        find "$dir" -name ".*" -prune -o \
            -type d -iname "$pattern" -print0 2>/dev/null
    fi
fi | while IFS= read -r -d '' path; do
        numfiles=$(find "$path" -type f -mindepth 1 | wc -l)
        numsubdirs=$(find "$path" -maxdepth 1 -type d -mindepth 1 | wc -l)
        stats=$(stat -c "%W %Y %X %s" "$path")
        isrootowned=$( [[ $(stat -c "%u" "$path") -eq 0 ]] && echo true || echo false)
        hasgit=$( [[ -d $path/.git ]] && echo true || echo false)

        printf '%s\t%s %s %s %s\n' "$path" "$stats" "$isrootowned" "$numfiles" "$numsubdirs $hasgit"
done | jq -R '
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