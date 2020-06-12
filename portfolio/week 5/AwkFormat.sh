#! /bin/bash

echo "Google Server IPs:"

awk '{
    print $1;
}' input.txt
