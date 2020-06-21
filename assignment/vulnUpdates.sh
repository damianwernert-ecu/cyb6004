#! /bin/bash

# Change the umask to 0177 so that any files this program creates are only readable and writable by the
# user that runs it.
umask 0177

# Identify the program name for later use
program=$(basename $0)

# Define the usage string for errors in invocation
usage="Usage: $pr [OPTIONS]

OPTIONS include:
    -h
        Extended help.

    -e earliest_time
        Set the earliest time to report vulnerabilities from.

    -s min_severity
        Set the minimum CVSS score to be reported on.

    -c
        Force an update on the cached NVD data.

    -u
        Supress reporting of NVD entries that have an unknown vulnerability score
"

# Initialize other variables
dataURL="https://nvd.nist.gov/feeds/json/cve/1.1/nvdcve-1.1-recent.json.gz"
dataFile="$HOME/.${program}.data.gz"

## Define functions

# ExtendedHelp is a self-made man page that give the user more detailed information about the script.
ExtendedHelp() {
    sed 's/^ *//' <<-!EOD | man -l -
    .\" Manpage for $program
    .\" Contact dwernert@our.ecu.edu.au for feedback.
    .TH $program 1 "16 June 2020" "1.0" "$program manual page"
    .SH NAME
    $program \- display recently discovered vulnerabilities
    .SH SYNOPSIS
    $program [OPTIONS]
    .SH DESCRIPTION
    $program is a program that retrives a list of recently updated vulnerabilities from the National Vulnerability Database
    (NVD). The user may determine how recently to report on the vulnerability updates. Updates are capped at a maximum of 8 days
    old, but may include vulnerabilities report well before that date, that have been updated within the last 8 days.
    .SH OPTIONS
    .B -h
    .IP
    Help message.
    .LP
    .B -e earliest_time
    .IP
    Where earliest_time is the earliest vulnerability to report.
    .LP
    .B -s severity
    .IP
    Severity is the Minimum vulnerability severity, that is the CVSS score. By default, CVSS V3 is used, but some vulnerabilities
    were first reported before CVSS V3 was created, so the V2 score is used instead. Occasionally, there are updates to
    vulnerabilities that do not have CVSS scores, so those scores will be zero, but will be reported anyway to err on the
    side of caution. This behaviour may be overridden by the -u option.
    .LP
    .B -c
    .IP
    Force the update of the cache with the current information.
    .LP
    .B -u
    .IP
    Suppress reporting of unknown vulnerability scores.
    .SH NOTES
    The program will create a cache file in $dataFile where it will store recent data. The NVD is updated every
    two hours and datestamped, so that if the datestamp is more than 2 hours out-of-date, a new copy will be automatically
    downloaded.  A cache update may be forced by using the -c option.
    .LP
    The National Vulnerability Database (NVD) is a database of all computer and network vulnerabilities reported, and includes
    descriptions and ratings. See https://nvd.nist.gov/vuln/data-feeds
    .SH BUGS
    Please report bugs to the author.
    .SH AUTHOR
    Damian Wernert (dwernert@our.ecu.edu.au)
	!EOD
    return $?
}

# Default values affected my command-line options
earliestTimeString="8 days ago"
minSeverity=0
updateCache=no
suppressUnknownScores=no

# Process command-line options
while getopts "ce:hs:u" opt; do
    case "$opt" in
    c)  updateCache=yes
        ;;
    e)  earliestTimeString="$OPTARG"
        ;;
    h)  ExtendedHelp
        exit $?
        ;;
    s)  minSeverity="$OPTARG"
        ;;
    u)  suppressUnknownScores=yes
        ;;
    *)  echo "$usage" >&2
        exit 1
        ;;
    esac
done
shift $(( OPTIND - 1 ))

# Convert earliestTimeString into an epoch time
earliestTime=$(date +%s -d"$earliestTimeString")
if [ $? -ne 0 ]; then
    echo "$program: the date string provided is invalid" >&2
    exit 2
fi

# Validate the input of minSeverity
if ! [[ $minSeverity =~ ^[0-9]*\.?[0-9]*$ ]]; then
    echo "$program: minimum severity is invalid" >&2
    exit 3
fi

# Find out if we have a data file, and if we need to update it
if  [ -r "$dataFile" ]; then
    # Find out how recent the data is
    dataDateString=$(gunzip -c "$dataFile" | jq -r '."CVE_data_timestamp"')
    dataDateEpoch=$(date +%s -d"$dataDateString")
    if [ $dataDateEpoch -le $(date +%s -d"2 hours ago") ]; then
        echo "$program: cached data is old - requesting update"
        updateCache=yes
    fi
else
    updateCache=yes
fi

# Now update the data file cache if necessary
if [ "$updateCache" = yes ]; then
    echo "$program: updating data cache"
    #wget -q -O "$dataFile" "$dataURL"
else
    echo "$program: using cached data"
fi

# Create a list of indexes corresponding to the array provided by the NVD.
arrayIndexes=$(gunzip -c "$dataFile"  | jq '."CVE_Items" | keys | .[]')
lastIndex=$(echo "$arrayIndexes" | tail -1)

# Record the number of reported vulnerabilites
numHits=0

# Display parameter data
echo "$program: searching through $lastIndex vulnerabilities for scores of $minSeverity or higher"

# Iterate through the array of vulnerabilities
for vuln in $arrayIndexes; do
    echo -ne "Searching $vuln of $lastIndex\r"

    # Retrieve the last modified date, and convert it to epoch time
    lastModifiedDateString=$(gunzip -c "$dataFile" | jq -r ".CVE_Items[${vuln}].lastModifiedDate")
    lastModifiedDateEpoch=$(date +%s -d"$lastModifiedDateString")

    # Find out if the lastModifiedDate is late enough to be listed
    if [ $lastModifiedDateEpoch -lt $earliestTime ]; then
        # The update date/time of this vulnerability is too early for the threshold, so we ignore it
        continue
    fi

    # Retrieve the impact score of the vulnerability, and fall back to V2 if necessary
    score=$(gunzip -c "$dataFile" | jq ".CVE_Items[${vuln}].impact.baseMetricV3.cvssV3.baseScore")
    if [ -z "$score" ]; then
        score=$(gunzip -c "$dataFile" | jq ".CVE_Items[${vuln}].impact.baseMetricV2.cvssV2.baseScore")
    fi

    # Find out if the score is greater than or equal to the score requested by the user
    if [ -z "$score" -o "$score" = "null" ]; then
        if [ "$suppressUnknownScores" = no ]; then
            displayScore="Unknown"
        else
            continue
        fi
    elif (( $(echo "$score < $minSeverity" | bc -l) )); then
        # The score of this vulnerability is too low for the threshold, so we ignore it
        continue
    else
        displayScore=$(printf "%3.1f" $score)
    fi

    # Retrieve the vulnerability ID
    vulnID=$(gunzip -c "$dataFile" | jq ".CVE_Items[${vuln}].cve.CVE_data_meta.ID")

    # Retrieve the vulnerability description. The -r option on jq removes the surrounding quotes
    description=$(gunzip -c "$dataFile" | jq -r ".CVE_Items[${vuln}].cve.description.description_data | .[].value")

    # Display the vulnerability data
    printf "%d: %s score = %s (Last updated %s)\n" $vuln "$vulnID" "$displayScore" "$lastModifiedDateString"
    echo "    Description:"
    echo "$description" | fold -s | awk '{print "        " $0 }'

    # Update the number of reported vulnerabilities
    (( numHits ++ ))
done

echo "$program: $numHits hits reported"
