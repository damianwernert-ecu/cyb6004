#!/bin/bash

progName=$(basename $0)

precision=4
equationRegex='^(-?[0-9]*\.?[0-9]+)[[:space:]]*([+/*-])[[:space:]]*(-?[0-9]*\.?[0-9]+)$'
precisionRegex='^pre[[:space:]]*([0-9]*)$'

black='\033[30m'
red='\033[31m'
green='\033[32m'
brown='\033[33m'
blue='\033[34m'
purple='\033[35m'
cyan='\033[36m'
grey='\033[37m'
bold='\033[1m'
resetColour='\033[0m'

shopt -s nocasematch

help() {
    echo "Enter a simple equation below. It must be of the format:"
    echo "  <number> <operator> <number>"
    echo "<number>s can have an optional leading negation sign, such as \"-4\" but not a positive sign."
    echo "examples:"
    echo "  3.1 / 4"
    echo "  4 * 5"
    echo " .2 * 5"
    echo " -1 + -4"
    echo "  0.4 - 5"
    echo "and hit enter to calculate"
    echo "You may also type:"
    echo -e "  ${bold}q${resetColour} to quit."
    echo -e "  ${bold}pre${resetColour} to see the current floating point precision"
    echo -e "  ${bold}pre <number>${resetColour} to set the current floating point precision to <number>"
    echo -e "  ${bold}help${resetColour} to see this mesasge again"
    echo ""
}

help

while :; do
    read -p "> " equation

    case "$equation" in
    q*|Q*|exit)    echo "Finished"
            exit 0
            ;;
    help)   help
            ;;
    pre*)   if [[ "$equation" =~ $precisionRegex ]]; then
                if [ -n "${BASH_REMATCH[1]}" ]; then
                    newPrecision="${BASH_REMATCH[1]}"
                    echo "Setting precision to $newPrecision"
                    precision="$newPrecision"
                else
                    echo "Precision = $precision"
                fi                         
            else
                echo "Error in precision get/setting"
            fi
            ;;
    "")     :
            ;;
    *)      if [[ "$equation" =~ $equationRegex ]]; then
                operator="${BASH_REMATCH[2]}"
                case "$operator" in
                \+) colour="$blue" ;;
                \-) colour="$green" ;;
                \*) colour="$red" ;;
                /)  colour="$purple"
                    divisor="${BASH_REMATCH[3]}"
                    if [ "$divisor" -eq 0 ]; then
                        echo "Divide by zero is not legal"
                        continue
                    fi
                    ;;
                esac

                echo -e "$colour\c"
                echo -e "scale = $precision\n$equation" | bc
                echo -e "$resetColour\c"
            else
                echo "Invalid format"
                help
            fi
            ;;
    esac
done
    
