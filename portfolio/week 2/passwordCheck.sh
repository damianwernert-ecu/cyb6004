#! /usr/bin/bash

# Get the name of the script without the leading path
pr=$(basename $0)

# Set the name of the secret file
secretFile="secret.txt"

# Define some colours
red='\033[31m'
green='\033[32m'
resetColour='\033[0m'

# Look for the secret file in the current directory. Note that there is no
# conventional place for this file to exist, so we are defaulting to the current
# working directory. If the file is not there, then exit with an error.
if [ ! -r "$secretFile" ]; then
    echo "$pr: cannot find secret file \"$secretFile\"" >&2
    exit 1
fi

# Read the password in without terminal echo
echo -en "$red"
read -sp "Enter your password to check: " password
echo

# check the password against the password stored in the secret file. Get rid of
# standard output from sha256sum because we don't need it.
echo -n "$password" | sha256sum -c secret.txt > /dev/null 2>&1
# Capture the return value from the last command executed (in this case,
# sha256sum).
returnValue=$?

# If the $returnValue is non-zero, then it has failed. If it is zero, then it's
# okay.
if [ $returnValue -eq 0 ]; then
    # Check was successful. Echo the required message and exit with a 0 exit
    # code, indicating success.
    echo -e "${green}Access Granted"
    echo -ne "${resetColour}"
    exit 0
fi

# Check was unsuccessful. Echo the required message and exit with a 1 exit
# code, indicating failure.
echo -e "${red}Access Denied"
echo -ne "${resetColour}"
exit 1
