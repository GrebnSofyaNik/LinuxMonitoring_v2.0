#!/bin/bash

. ./check_functions.sh

path="../01/log.txt"

function parsing_log_file {
    i=0
    while IFS= read -r line
    do
        files[$i]=$( echo "$line" | awk '{ print $1 }' )
        i=$(( $i + 1 ))
    done < $path
}

function clean {
    for i in ${!files[@]}
    do
        if [[ -d ${files[$i]} ]]
        then
            sudo rm -rf ${files[$i]}
        fi  
    done
}

if [[ -f $path ]]
then
    parsing_log_file
    clean
else
    print_error "3"
fi
