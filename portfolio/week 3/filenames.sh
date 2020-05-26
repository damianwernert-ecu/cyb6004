#!/bin/bash

prog=$(basename $0)
usage="Usage: $pr file
where
    file = a file containing a list of potential files/directories"

[ $# -ne 1 ] && echo "$usage" >&2 && exit 1

inputFile="$1"

while IFS= read fileLine; do
    if [ -f "$fileLine" ]; then
        echo "$fileLine - That file exists"
    elif [ -d "$fileLine" ]; then
        echo "$fileLine - That's a directory"
    else
        echo "$fileLine - I don't know what that is!"
    fi
done < "$inputFile"

exit 0
