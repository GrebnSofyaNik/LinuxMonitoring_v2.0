#!/bin/bash

if [[ $# -ne 0 ]]
then
    echo "The script should run without parameters!" >&2
    exit 1
fi

path="../04"
for (( i=1; i < 6; i++))
do
    if [[ -f "${path}/$i.log" ]]
    then
        output=1
    else
        output=0
        echo "Log-file ${path}/$i.log does not exist!" >&2
        break
    fi
done

if [[ $output -eq 1 ]]
then
    sudo apt install -y goaccess

    goaccess ${path}/*.log --log-format=COMBINED --time-format=%T -o report.html
fi