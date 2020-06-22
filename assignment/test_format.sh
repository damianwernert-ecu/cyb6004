#! /bin/bash

vuln=1234
vulnID=CVE-9999-12345
displayScore=10.0
lastModifiedDateString=$(date)
description="A CWE-1103: Use of Platform-Dependent Third Party Components with vulnerabilities vulnerability exists in Easergy T300 (Firmware version 1.5.2 and older) which could allow an attacker to exploit the component."

# Display the vulnerability data
printf "%d: %s score = %s (Last updated %s)\n" $vuln "$vulnID" "$displayScore" "$lastModifiedDateString"
echo "    Description:"
echo -e "$description\n" | fold -s | awk '{print "        " $0 }'

#perl -e 'print("arg 1 = ", $ARGV[0], "\n");' stuff
perl -e '

# Grab values from command line
my ($vulnNbr, $vulnID, $score, $lastModified, $description) = @ARGV;

# Create the perl format record
format OUTPUT_RECORD = 
@<<<: @<<<<<<<<<<<<< score = @#.# (Last updated @<<<<<<<<<<<<<<<<<<<<<<<<<<<<)
$vulnNbr,$vulnID,$score,$lastModified
    @<<<<<<<<<<<
    "Description:"
        ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        $description
        ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        $description
        ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        $description
        ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<...
        $description

.

# Select STDOUT as the write descriptor for the write command
select(STDOUT);
$~ = OUTPUT_RECORD;  # Set the default format for write.
write;  # Perform the write out.
' "$vuln" "$vulnID" "$displayScore" "$lastModifiedDateString" "$description"
