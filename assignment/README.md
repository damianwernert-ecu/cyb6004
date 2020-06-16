# Bash program for cybersecurity

## Purpose
The purpose of this program is to display recent vulnerabilities.

## Usage

newVulns.sh [-h]
    where:
    -h  Help message. A more extensive description than this usage message. If this option is present, all other options are
        ignored.

newVulns.sh [-l "last_time"] [-s min_score]
    where:
    -l  last_time
        *last_time* is the time representing the earliest report of a vulnerability. The default is 8 days, meaning that any
        vulnerabilities recorded in the last 8 days will be displayed. The time format for *last_time* is largely human readable,
        so valid examples are "00:00" for midnight, "1 day ago" for yesterday, "16:00 yesterday" for 4pm yesterday, and so on.
        Absolute date formats are possible too, such as "1 Jan 2020". Any date in the future will cause an error.

    -s  min_score
        *min_score* is the lowest CVE score that a vulnerability must have to be reported. Default minimum score is 0.

### Caching
The program will create a cache directory under $HOME/newVulns.sh where it will store recent data. The NVD is updated every two
hours so there is little point to querying it any more frequently than that. Therefore if one or more queries are done within two
hours of another query, the program will used cached data. Once the cached data is expired, new data will be downloaded into the
cache and used.  A cache update may be forced by using the -c option.
    
### Examples:
Return all vulnerabilities logged in the last 8 days:
    newVulns.sh

Return all vulnerabilities since midnight:
    newVulns.sh -l 00:00

Return all vulnerabilities with a score higher than 5 in the last week:
    newVulns.sh -1 "1 week ago" -s 5
