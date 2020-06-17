#! /bin/bash

ExtendedHelp1() {
    echo "
    LlwiIE1hbnBhZ2UgZm9yIG5ld1Z1bG5zLnNoCi5cIiBDb250YWN0IGR3ZXJuZXJ0QG91ci5lY3Uu
    ZWR1LmF1IGZvciBmZWVkYmFjay4KLlRIIG5ld1Z1bG5zLnNoIDEgIjE2IEp1bmUgMjAyMCIgIjEu
    MCIgIm5ld1Z1bG5zLnNoIG1hbnVhbCBwYWdlIgouU0ggTkFNRQpuZXdWdWxucy5zaCBcLSBkaXNw
    bGF5IHJlY2VudGx5IGRpc2NvdmVyZWQgdnVsbmVyYWJpbGl0aWVzCi5TSCBTWU5PUFNJUwpuZXdW
    dWxucy5zaCBbT1BUSU9OU10KLlNIIERFU0NSSVBUSU9OCm5ld1Z1bG5zLnNoIGlzIGEgcHJvZ3Jh
    bSB0aGF0IHJldHJpdmVzIGEgbGlzdCBvZiByZWNlbnRseSBkaXNjb3ZlcmVkIHZ1bG5lcmFiaWxp
    dGllcyBmcm9tIHRoZSBOYXRpb25hbCBWdWxuZXJhYmlsaXR5IERhdGFiYXNlCihOVkQpLiBUaGUg
    dXNlciBtYXkgZGV0ZXJtaW5lIGhvdyByZWNlbnQgdGhlIHZ1bG5lcmFiaWxpdGllcyBhcmUsIGJ1
    dCBhcyB0aGUgTlZEIGlzIG9ubHkgdXBkYXRlZCBldmVyeSB0d28gaG91cnMsIHRoZXJlIGlzIGxp
    dHRsZSBuZWVkIHRvIHF1ZXJ5IGFueSBtb3JlIGZyZXF1ZW50bHkgdGhhbiB0aGF0LgouU0ggT1BU
    SU9OUwouQiAtaAouUFAKLklQCkhlbHAgbWVzc2FnZS4KLkxQCi5CIC1sIGxhc3RfdGltZQouSVAK
    V2hlcmUgbGFzdF90aW1lIGlzIHRoZSBlYXJsaWVzdCB2dWxuZXJhYmlsaXR5IHRvIHJlcG9ydC4K
    LkxQCi5CIC1zIHNldmVyaXR5Ci5JUApTZXZlcml0eSBoZXJlIGlzIHRoZSBNaW5pbXVtIHZ1bG5l
    cmFiaWxpdHkgc2V2ZXJpdHksIHRoYXQgaXMgdGhlIENWU1Mgc2NvcmUuCi5MUAouQiAtYwouSVAK
    Rm9yY2UgdGhlIHVwZGF0ZSBvZiB0aGUgY2FjaGUgd2l0aCB0aGUgY3VycmVudCBpbmZvcm1hdGlv
    bi4KLlNIIE5PVEVTClRoZSBwcm9ncmFtIHdpbGwgY3JlYXRlIGEgY2FjaGUgZGlyZWN0b3J5IHVu
    ZGVyICRIT01FL25ld1Z1bG5zLnNoIHdoZXJlIGl0IHdpbGwgc3RvcmUgcmVjZW50IGRhdGEuIFRo
    ZSBOVkQgaXMgdXBkYXRlZCBldmVyeSB0d28KaG91cnMgc28gdGhlcmUgaXMgbGl0dGxlIHBvaW50
    IHRvIHF1ZXJ5aW5nIGl0IGFueSBtb3JlIGZyZXF1ZW50bHkgdGhhbiB0aGF0LiBUaGVyZWZvcmUg
    aWYgb25lIG9yIG1vcmUgcXVlcmllcyBhcmUgZG9uZSB3aXRoaW4gdHdvCmhvdXJzIG9mIGFub3Ro
    ZXIgcXVlcnksIHRoZSBwcm9ncmFtIHdpbGwgdXNlZCBjYWNoZWQgZGF0YS4gT25jZSB0aGUgY2Fj
    aGVkIGRhdGEgaXMgZXhwaXJlZCwgbmV3IGRhdGEgd2lsbCBiZSBkb3dubG9hZGVkIGludG8gdGhl
    CmNhY2hlIGFuZCB1c2VkLiAgQSBjYWNoZSB1cGRhdGUgbWF5IGJlIGZvcmNlZCBieSB1c2luZyB0
    aGUgLWMgb3B0aW9uLgouTFAKVGhlIE5hdGlvbmFsIFZ1bG5lcmFiaWxpdHkgRGF0YWJhc2UgKE5W
    RCkgaXMgYSBkYXRhYmFzZSBvZiBhbGwgY29tcHV0ZXIgYW5kIG5ldHdvcmsgdnVsbmVyYWJpbGl0
    aWVzIHJlcG9ydGVkLCBhbmQgaW5jbHVkZXMKZGVzY3JpcHRpb25zIGFuZCByYXRpbmdzLgouU0gg
    QlVHUwpQbGVhc2UgcmVwb3J0IGJ1Z3MgdG8gdGhlIGF1dGhvci4KLlNIIEFVVEhPUgpEYW1pYW4g
    V2VybmVydCAoZHdlcm5lcnRAb3VyLmVjdS5lZHUuYXUpCg==
    " | tr -d ' ' | base64 -d | man -l -
    return 0
}

ExtendedHelp2() {
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
    (NVD). The user may determine how recent the vulnerabilities are, but as the NVD is only updated every two hours, there is little need to query any more frequently than that.
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
    The program will create a cache directory under $HOME/newVulns.sh where it will store recent data. The NVD is updated every two
    hours so there is little point to querying it any more frequently than that. Therefore if one or more queries are done within two
    hours of another query, the program will used cached data. Once the cached data is expired, new data will be downloaded into the
    cache and used.  A cache update may be forced by using the -c option.
    .LP
    The National Vulnerability Database (NVD) is a database of all computer and network vulnerabilities reported, and includes
    descriptions and ratings.
    .SH BUGS
    Please report bugs to the author.
    .SH AUTHOR
    Damian Wernert (dwernert@our.ecu.edu.au)
	!EOD
}
ExtendedHelp2
