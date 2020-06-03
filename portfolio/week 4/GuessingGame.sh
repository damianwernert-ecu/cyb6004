#!/bin/bash

correct=42

# This function prints a given error
printError()
{
    echo -e "\033[31mERROR:\033[0m $1"
}

# This function will get a value between the 2nd and 3rd arguments
getNumber()
{
    read -p "$1: "
    while (( $REPLY < $2 || $REPLY > $3 )); do
        printError "Input must be between $2 and $3"
        read -p "$1: "
    done
    return $REPLY
}

while :; do
    getNumber "please type a number between 1 and 100" 1 100
    guess=$?
    if (( guess > $correct )); then
        echo "Too High!"
    elif (( guess < $correct )); then
        echo "Too Low!"
    else
        break
    fi
done

echo "Correct!"

exit 0
