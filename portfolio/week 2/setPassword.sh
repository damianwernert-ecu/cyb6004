#! /usr/bin/bash

# This is the name of the file that will store the password
secretFile="secret.txt"

# Use $pr as the name of the script file, without the leading path
pr=$(basename $0)

# Read in the folder name to store the secret.txt file
read -p "Enter a folder name: " folderName

# Test if the folder already exists
if [ ! -d "$folderName" ]; then
    # If the folder doesn't exist, try to create it
    if ! mkdir -p "$folderName"; then
        # If the creation fails, exit with an error message sent to STDERR,
        # and an exit return value of 1 (non-zero)
        echo "$pr: cannot create folder \"$folderName\"" >&2
        exit 1
    fi
fi
		
# Prompt for a password, while supressing terminal echo
read -sp "Enter a password: " aPassword
# Produce a solitary newline to neaten the output of the script
echo

# The file to store the secret in will be the name of the directory supplied by
# the user and the name of the secret file defined earlier
passwordFile="${folderName}/${secretFile}"

# Feed the password (without a newline) through the sha256sum hash generation
# program and send the output to the password file.
if echo -n "$aPassword" | sha256sum > "$passwordFile"; then
    # If this process was succesful, then exit successfully.
    echo "$pr: successful"
    exit 0
fi

# At this point, the process was not successful so exit with failure.
echo "$pr: failed" >&2
exit 2
