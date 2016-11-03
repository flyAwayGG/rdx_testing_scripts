#!/bin/bash
### Show diffrence between installed packages and packages listed in .pkg file
### Need rework for showing diffrence in two ways

# First argument is path to .pkg file with names of desired rpm packages
RAW_EXPECTED_PKG=$1;
rpm -qa > /root/actual_pkg;

cat $RAW_EXPECTED_PKG | cut -f2 -d: > /root/expected_pkg;
grep -vFxf /root/actual_pkg /root/expected_pkg; 
