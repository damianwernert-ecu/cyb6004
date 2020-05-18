#! /usr/bin/bash

pr=$(basename $0)

secretFile="secret.txt"

if [ ! -r "$secretFile" ]; then
    echo "$pr: cannot find secret file \"$secretFile\"" >&2
    exit 1
fi

read -sp "Enter your password to check: " password
echo

echo -n "$password" | sha256sum -c secret.txt > /dev/null 2>&1
returnValue=$?

if [ $returnValue -eq 0 ]; then
    # Check was successful
    echo "Access Granted"
    exit 0
fi

echo "Access Denied"
exit 1
