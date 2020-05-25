#!/bin/bash

echo "Snippet testing"
black='\033[30m'
red='\033[31m'
green='\033[32m'
brown='\033[33m'
blue='\033[34m'
purple='\033[35m'
cyan='\033[36m'
grey='\033[37m'

echo -e "${black}Black text ${red}Red text"
echo -e "${green}Green text ${Brown}Brown text"
echo -e "${blue}Blue text ${purple}purple text"
echo -e "${cyan}Cyan text ${grey}Grey text"

for anIP in 192.168.0.1 192.168.0.0 260.0.0.1 0.0.0.0 0.1000.0.2 1.1.270.3 1.2.3.400; do
    if [[ "ip" =~ ^(([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))\.){3}([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))$ ]]; then
    :
    else
    :
    fi
done