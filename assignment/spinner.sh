#! /bin/bash

ary=( "/" "-" "\\\\" "|")

arySize=${#ary[@]}

echo "array = $ary"
echo "array size = $arySize"
aryIdx=0

while :; do
    echo -ne "Doing: ${ary[ (( aryIdx % arySize)) ]}\r"
    (( aryIdx++ ))
    sleep 0.1
done
