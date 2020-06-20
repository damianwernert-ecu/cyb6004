#! /bin/bash

# This is a bash wrapper around an awk script.

awk -F: 'BEGIN {
    # Define colours
    black = "\033[30m"
    red = "\033[31m"
    green = "\033[32m"
    brown = "\033[33m"
    blue = "\033[34m"
    purple = "\033[35m"
    cyan = "\033[36m"
    grey = "\033[37m"
    bold = "\033[1m"
    resetColour = "\033[0m"

    # This printf statement prints the headings
    printf("| %s%-17s%s| %s%-7s%s| %s%-8s%s| %s%-25s%s| %s%-18s%s|\n",
        blue, "Username", resetColour,
        blue, "UserID", resetColour,
        blue, "GroupID", resetColour,
        blue, "Home", resetColour,
        blue, "Shell", resetColour)

    # This printf statemetn prints the underlines for the headings
    printf("| %-17s| %-7s| %-8s| %-25s| %-18s|\n",
        "_________________",
        "_______",
        "________",
        "_________________________",
        "__________________")

}

# Match all lines that end in "/bin/bash", and run the following for each.
/\/bin\/bash$/ {
    # Prints the lines in /etc/passwd of interest.
    printf("| %s%-17s%s| %s%-7s%s| %s%-8s%s| %s%-25s%s| %s%-18s%s|\n",
        green, $1, resetColour,
        green, $3, resetColour,
        green, $4, resetColour,
        green, $6, resetColour,
        green, $7, resetColour)
}
END {
}' /etc/passwd

# Exit with the same code as awk does.
exit $?
