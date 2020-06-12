#!/bin/bash

program=$(basename $0)
usage="Usage: $program [dir]
If dir is not specified, then the current directory is assumed."

if [ -n "$1" ]; then
    [ ! -d "$1" ] && echo "$program: \"$1\" is not a directory" >&2 && exit 1
    startDir="$1"
else
    startDir="."
fi

echo "1. All sed statements"
grep -r "sed" "$startDir"

echo "2. All lines that start with the letter m"
grep -r "^m" "$startDir"

echo "3. All lines that contain three digit numbers"
grep -r "[0-9][0-9][0-9]" "$startDir"

echo "4. All echo statements with at least three words"
grep -r "echo[[:space:]]*[[:alpha:]]*[[:space:]]*[[:alpha:]]*[[:space:]]*[[:alpha:]]*" "$startDir"

echo "5. All lines that would make a good password (use your knowledge of cybersecurity to decide what makes a good password)."
grep -Eor "[^[:space:]]{10,}" "$startDir" | grep "[a-z]" | grep "[A-Z]" | grep "[[:punct:]]" | grep "[0-9]"
