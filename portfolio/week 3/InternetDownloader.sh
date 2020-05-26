#!/bin/bash

while :; do
    read -p "Please type in a URL to download, or \"exit\" to quit: " input

    case "$input" in
    exit|EXIT|quit|QUIT)  echo "Finished"
        exit 0
        ;;
    esac

    read -p "Enter the location for the download: " target
    target=$(eval echo "$target")

    if ! cd "$target"; then
        echo "The download location is invalid"
        continue
    fi

    #if wget --quiet --show-progress --progress=bar "$target" "$input"; then
    if wget "$input"; then
        echo "Download successful"
    else
        echo "Download failed"
    fi
done
