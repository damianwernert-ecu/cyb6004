#!/bin/bash

# This script runs the IpIinfo.sh script and filters the output with sed. It uses the -n
# option to supress printing by default, and then the "p" sed command to print lines that
# match the string "IP Address"./
./IpInfo.sh  | sed -n '/IP Address/ p'
