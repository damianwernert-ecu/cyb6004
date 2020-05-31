#! /bin/bash

scriptList=(
    "$HOME/scripts/portfolio/week 2/foldermaker.sh::Create a folder" \
    "$HOME/scripts/portfolio/week 2/foldercopier.sh::Copy a folder" \
    "$HOME/scripts/portfolio/week 2/setPassword.sh::Set a password" \
    "$HOME/scripts/portfolio/week 3/calculator.sh::Calculator" \
    "$HOME/scripts/portfolio/week 3/megafoldermaker.sh::Create Week Folders" \
    "$HOME/scripts/portfolio/week 3/filenames.sh:filenames.txt:Check Filenames" \
    "$HOME/scripts/portfolio/week 3/InternetDownloader.sh::Download a File" \
)

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

returnValue=0
runScript() {
    local scriptDir=$(dirname "$1")
    local scriptName=$(basename "$1")
    shift

    local BACK=$(pwd)

    if cd "$scriptDir"; then
        "./$scriptName" "$@"
        returnValue=$?
        cd "$BACK"
    else
        echo "Could not change directory to $scriptDir"
        returnValue=1
    fi
}

runScript "$HOME/scripts/portfolio/week 2/passwordCheck.sh"
if [[ $returnValue -ne 0 ]]; then
    echo -en "$resetColour"
    exit 1
fi

echo -e "${purple}Select an option:"
echo -en "$blue"
for scriptIndex in "${!scriptList[@]}"; do
    scriptPath=$(echo "${scriptList[$scriptIndex]}" | cut -f1 -d:)
    scriptDescription=$(echo "${scriptList[$scriptIndex]}" | cut -f3 -d:)
    printf "%2d. %s\n" "$(( $scriptIndex + 1 ))" "$scriptDescription"
done
echo -en "$resetColour"
printf "%2d. %s\n" "$(( ${#scriptList[@]} + 1 ))" "Exit"

while :; do
    read -p "Enter your choice: " choice

    if [[ "$choice" =~ ^[0-9]+$ ]]; then
        # choice is an integer. Checking if it's in range
        if (( choice >= 1 )) && (( choice <= ${#scriptList[@]} )); then
            break
        elif (( choice == ${#scriptList[@]} + 1 )); then
            echo "Finished."
            exit 0
        else
            echo "Your choice was out of range."
        fi
    else
        echo "Please enter a number for your choice"
    fi
done

indexToRun=$((choice - 1))
runScript "$(echo "${scriptList[$indexToRun]}" | cut -f1 -d:)" "$(echo "${scriptList[$indexToRun]}" | cut -f2 -d:)"

echo -en "$resetColour"

exit 0
