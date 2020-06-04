#!/bin/bash

./IpInfo.sh  | sed -n '/IP Address/ p'
