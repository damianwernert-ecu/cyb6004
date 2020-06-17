#! /bin/bash

# Identify the program name for later use
program=$(basename $0)

# Define the usage string for errors in invocation
usage="Usage: $pr [OPTIONS]

OPTIONS include:
    -h
        Extended help.

    -l last_time
        Set the earliest time to report vulnerabilities from.

    -s min_severity
        Set the minimum CVSS score to be reported on.

    -c
        Force an update on the cached NVD data."

## Define functions

ExtendedHelp() {
    sed 's/^ *//' <<-'!EOD' | man -l -
    .\" Manpage for newVulns.sh
    .\" Contact dwernert@our.ecu.edu.au for feedback.
    .TH newVulns.sh 1 "16 June 2020" "1.0" "newVulns.sh manual page"
    .SH NAME
    newVulns.sh \- display recently discovered vulnerabilities
    .SH SYNOPSIS
    newVulns.sh [OPTIONS]
    .SH DESCRIPTION
    newVulns.sh is a program that retrives a list of recently discovered vulnerabilities from the National Vulnerability Database
    (NVD). The user may determine how recent the vulnerabilities are, but as the NVD is only updated every two hours, there is
    little need to query any more frequently than that.
    .SH OPTIONS
    .B -h
    .PP
    .IP
    Help message.
    .LP
    .B -l last_time
    .IP
    Where last_time is the earliest vulnerability to report.
    .LP
    .B -s severity
    .IP
    Severity here is the Minimum vulnerability severity, that is the CVSS score.
    .LP
    .B -c
    .IP
    Force the update of the cache with the current information.
    .SH NOTES
    The program will create a cache directory under $HOME/newVulns.sh where it will store recent data. The NVD is updated every
    two hours so there is little point to querying it any more frequently than that. Therefore if one or more queries are done
    within two hours of another query, the program will used cached data. Once the cached data is expired, new data will be
    downloaded into the cache and used.  A cache update may be forced by using the -c option.
    .LP
    The National Vulnerability Database (NVD) is a database of all computer and network vulnerabilities reported, and includes
    descriptions and ratings.
    .SH BUGS
    Please report bugs to the author.
    .SH AUTHOR
    Damian Wernert (dwernert@our.ecu.edu.au)
	!EOD
}
