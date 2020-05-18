#! /usr/bin/bash

# Get the name of the script without the leading path
pr=$(basename $0)

# Set the name of the secret file
secretFile="secret.txt"

# Look for the secret file in the current directory. Note that there is no
# conventional place for this file to exist, so we are defaulting to the current
# working directory. If the file is not there, then exit with an error.
if [ ! -r "$secretFile" ]; then
    echo "$pr: cannot find secret file \"$secretFile\"" >&2
    exit 1
fi

# Read the password in without terminal echo
read -sp "Enter your password to check: " password
echo

# check the password against the password stored in the secret file. Get rid of
# standard output from sha256sum because it can be a bit obtuse.
echo -n "$password" | sha256sum -c secret.txt > /dev/null 2>&1
# Capture the return value from the last command executed (in this case,
# sha256sum).
returnValue=$?

# If the $returnValue is non-zero, then it has failed. If it is zero, then it's
# okay.
if [ $returnValue -eq 0 ]; then
    # Check was successful. Echo the required message and exit with a 0 exit
    # code, indicating success.
    echo "Access Granted"
    exit 0
fi

# Check was unsuccessful. Echo the required message and exit with a 1 exit
# code, indicating failure.
echo "Access Denied"
exit 1
