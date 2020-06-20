#!/bin/bash

ipAddressScript="./IpInfo.sh"

# Check that the ipAddressScript exists and is executable, and if not, error out.
[ ! -x "$ipAddressScript" ] && echo "Script $ipAddressScript not found - exiting" >&2 && exit 1

# This script runs the IpIinfo.sh script and filters the output with sed. It uses the -n
# option to supress printing by default, and then the "p" sed command to print lines that
# match the string "IP Address"./
$ipAddressScript  | sed -n '/IP Address/ p'
