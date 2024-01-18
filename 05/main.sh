#!/bin/bash

chmod +x sorting.sh

. ./sorting.sh

if [[ $# -ne 1 ]] || [[ ! $1 =~ ^[1-4]$ ]]
then
    echo "You need to specify 1 parameter! 1-code_sorting 2-all_uniq_ip 3-error_code 4-error_uniq_ip" >&2
    exit 1
fi

function selector {
    case $1 in
    1) code_sorting;;
    2) all_uniq_ip;;
    3) error_code;;
    4) error_uniq_ip;;
    esac
}

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
    selector $1
fi
