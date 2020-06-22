#! /bin/bash

# Change the umask to 0177 so that any files this program creates are only readable and writable by the
# user that runs it.
umask 0177

# Identify the program name for later use
PROGRAM=$(basename $0)

# Initialize other variables
DATA_URL="https://nvd.nist.gov/feeds/json/cve/1.1/nvdcve-1.1-recent.json.gz"
META_URL="https://nvd.nist.gov/feeds/json/cve/1.1/nvdcve-1.1-recent.meta"
DATA_FILE="$HOME/.${PROGRAM}.data.gz"
MAX_CACHE_AGE=2   # hours

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

## Define functions

# ExtendedHelp is a self-made man page that give the user more detailed information about the script.
ExtendedHelp() {
    sed 's/^ *//' <<-!EOD | man -l -
    .\" Manpage for $PROGRAM
    .\" Contact dwernert@our.ecu.edu.au for feedback.
    .TH $PROGRAM 1 "16 June 2020" "1.0" "$PROGRAM manual page"
    .SH NAME
    $PROGRAM \- display recently discovered vulnerabilities
    .SH SYNOPSIS
    $PROGRAM [OPTIONS]
    .SH DESCRIPTION
    $PROGRAM is a program that retrives a list of recently updated vulnerabilities from the National Vulnerability Database
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
    The program will create a cache file in $DATA_FILE where it will store recent data. The NVD is updated every
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
    # Note that on the preceding line, it is specifically indented with a tab, and not spaces. This is to make the indented
    # !EOD work.
    return $?
}

RetrieveMeta() {
    local rawMetadata
    local modifiedDate
    local modifiedEpoch
    local fileSize
    local sha256

    rawMetadata=$(wget -qO - "$META_URL" | sed -e "s/\r//g")
    modifiedDate=$(echo "$rawMetadata" | grep "^lastModifiedDate:" | cut -f2- -d:)
    modifiedEpoch=$(date +%s -d"${modifiedDate}")
    fileSize=$(echo "$rawMetadata" | grep "^zipSize:" | cut -f2 -d:)
    sha256=$(echo "$rawMetadata" | grep "^sha256:" | cut -f2 -d:)

    # Make sure we have some values
    if [ -z "$modifiedEpoch" -o -z "$fileSize" -o -z "$sha256" ]; then
        echo "$PROGRAM: failed to retrieve metadata" >&2
        return 1
    fi

    # "return" the data by stdout
    echo "$modifiedEpoch $fileSize $sha256"
    return 0
}

DownloadData() {
    local fileName
    local fileSize
    local checksum

    fileName="$1"
    fileSize="$2"
    checksum="$3"

    # Download data and compare with sizes and checksum
    wget -q -O "$fileName" "$DATA_URL"

    # check we have a file to look at
    if [ ! -r "$fileName" ]; then
        echo "$PROGRAM: file did not download to $fileName correctly" >&2
        return 1
    fi

    # Original intention was to compare sizes with files, but the file sizes were usually never in sync, so file
    # size check was removed.
    fileChecksum=$(gunzip -c "$fileName" | sha256sum - | awk '{print toupper($1)}')
    if [ "$fileChecksum" = "$checksum" ]; then
        echo "$PROGRAM: download successful"
        return 0
    else
        echo "$PROGRAM: file checksum ($fileChecksum) incorrect. Expected: $checksum" >&2
        return 1
    fi
}

UpdateCache() {
    local dataFile="$1"
    local forceUpdate="$2"
    local maxAge="$3"   # Hours
    local dataDateString
    local dataDateEpoch
    local metaDate
    local gzipSize
    local sha256checksum
    local ageCutoff=$(date +%s -d"${maxAge} hours ago")
    local getDownload=no

    # We must minimise the the number of downloads. The NVD has two URLs in relation to the data:
    # 1. the metadata URL (which holds update time, sizes and checksum information); and
    # 2. the actual data URL.
    # The metadata can be used to both:
    # 1. verify a download; and
    # 2. to examine if newer data exists for a download to occur.

    # Metadata is required for all circumstances except for one: when our datafile exists, its data is recent enough, and
    # the user hasn't forced a download with the -c option. We will check for this condition first:
    if [ -r "$dataFile" ]; then
        dataDateString=$(gunzip -c "$dataFile" | jq -r '."CVE_data_timestamp"')
        dataDateEpoch=$(date +%s -d"$dataDateString")

        # If the data is recent, then no download is needed, unless the user forced the download.
        if [ "$forceUpdate" = "no" ]; then
            if [ $dataDateEpoch -gt $ageCutoff ]; then
                echo "$PROGRAM: our data is less than $maxAge hours old - no download needed"
                return 0
            fi
        fi
    fi

    # From now on, we need the metadata provided by the NVD about new downloads.
    read metaDate gzipSize sha256checksum <<< $(RetrieveMeta)

    # If there is no datafile, or an update is forced, then we download data, using the metadata to verify the download.
    echo "DIAG: UpdateCache: dataFile = $dataFile"
    echo "DIAG: UpdateCache: forceUpdate = $forceUpdate"
    echo "DIAG: UpdateCache: gzipSize = $gzipSize"
    echo "DIAG: UpdateCache: sha256checksum = $sha256checksum"
    if [ ! -r "$dataFile" ] || [ "$forceUpdate" = "yes" ]; then
        echo "$PROGRAM: downloading new data"
        DownloadData "$dataFile" "$gzipSize" "$sha256checksum" && return 0
        return 1
    fi

    # If we get this far, the datafile must exist, and it is old. We look at the metadata's last update to see if we should
    # download new data.
    if [ $metaDate -le $dataDateEpoch ]; then
        echo "$PROGRAM: updating new data"
        DownloadData "$dataFile" "$gzipSize" "$sha256checksum" && return 0
        return 1
    else
        echo "$PROGRAM: no new data on the NVD server"
        return 0
    fi
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
    echo "$PROGRAM: the date string provided is invalid" >&2
    exit 2
fi

# Validate the input of minSeverity
if ! [[ $minSeverity =~ ^[0-9]*\.?[0-9]*$ ]]; then
    echo "$PROGRAM: minimum severity is invalid" >&2
    exit 3
fi

# Find out if we have a data file, and if we need to update it
UpdateCache "$DATA_FILE" "$updateCache" "$MAX_CACHE_AGE"
if [ $? -ne 0 ]; then
    echo "$PROGRAM: data download or update failed" >&2
    exit 4
fi

# Create a list of indexes corresponding to the array provided by the NVD.
arrayIndexes=$(gunzip -c "$DATA_FILE"  | jq '."CVE_Items" | keys | .[]')
lastIndex=$(echo "$arrayIndexes" | tail -1)

# Record the number of reported vulnerabilites
numHits=0

# Display parameter data
echo "$PROGRAM: searching through $lastIndex vulnerabilities for scores of $minSeverity or higher since $(date -d@${earliestTime})"

# Iterate through the array of vulnerabilities
for vuln in $arrayIndexes; do
    echo -ne "Searching $vuln of $lastIndex\r"

    # Retrieve the last modified date, and convert it to epoch time
    lastModifiedDateString=$(gunzip -c "$DATA_FILE" | jq -r ".CVE_Items[${vuln}].lastModifiedDate")
    lastModifiedDateEpoch=$(date +%s -d"$lastModifiedDateString")

    # Find out if the lastModifiedDate is late enough to be listed
    if [ $lastModifiedDateEpoch -lt $earliestTime ]; then
        # The update date/time of this vulnerability is too early for the threshold, so we ignore it
        continue
    fi

    # Retrieve the impact score of the vulnerability, and fall back to V2 if necessary
    score=$(gunzip -c "$DATA_FILE" | jq ".CVE_Items[${vuln}].impact.baseMetricV3.cvssV3.baseScore")
    if [ -z "$score" ]; then
        score=$(gunzip -c "$DATA_FILE" | jq ".CVE_Items[${vuln}].impact.baseMetricV2.cvssV2.baseScore")
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
    vulnID=$(gunzip -c "$DATA_FILE" | jq ".CVE_Items[${vuln}].cve.CVE_data_meta.ID")

    # Retrieve the vulnerability description. The -r option on jq removes the surrounding quotes
    description=$(gunzip -c "$DATA_FILE" | jq -r ".CVE_Items[${vuln}].cve.description.description_data | .[].value")

    # Display the vulnerability data
    printf "%d: %s score = %s (Last updated %s)\n" $vuln "$vulnID" "$displayScore" "$lastModifiedDateString"
    echo "    Description:"
    echo -e "$description\n" | fold -s | awk '{print "        " $0 }'

    # Update the number of reported vulnerabilities
    (( numHits ++ ))
done

echo "$PROGRAM: $numHits hits reported"
