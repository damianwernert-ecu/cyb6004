#!/bin/bash

# Program to echo the first given argument to the user.

# Check that the user has supplied an argument.
if [ -z "$1" ]; then
    echo "Usage: $0 name" >&2
    exit 1
fi

echo "Hi there!"
echo "It's good to see you $1!"

exit 0
