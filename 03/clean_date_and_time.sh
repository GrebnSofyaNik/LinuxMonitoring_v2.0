#!/bin/bash

. ./check_functions.sh

echo -n "Enter start date and time [DD.MM.YY HH:MM]: "
read answer

function get_date {
    input_date="$1"
    if [[ $( echo "$input_date" | grep -E "^[0-9]+\.[0-9]+\.[0-9]+ [0-9]+\:[0-9]+$" ) ]]
    then
        IFS=' ' read -ra input_date <<< "$input_date"
        input_day=${input_date[0]}
        IFS='.' read -ra input_day <<< "$input_day"
        input_time=${input_date[1]}
        IFS=':' read -ra input_time <<< "$input_time"
        echo "${input_day[@]} ${input_time[@]}"
    else
        print_error "4"
    fi
}

start_date=($( get_date "$answer" ))

if [[ ${#start_date[@]} -ne 0 ]]
then
    output=$( check_input_date "${start_date[*]}" )
else
    output=0
fi

if [[ $output -ne 0 ]]
then
    echo -n "Enter end date and time [DD.MM.YY HH:MM]: "
    read answer

    end_date=($( get_date "$answer" ))

    if [[ ${#end_date[@]} -ne 0 ]]
    then
        output=$( check_input_date "${end_date[*]}" )
    else
        output=0
        print_error "4"
    fi
fi

function get_date_in_sec {
    input_date=( $1 )
    echo "$( date +%s -d "${input_date[2]}-${input_date[1]}-${input_date[0]} ${input_date[3]}:${input_date[4]}:00" )"
}

if [[ $output -ne 0 ]]
then
    start_date_in_sec=$( get_date_in_sec "${start_date[*]}" )
    end_date_in_sec=$( get_date_in_sec "${end_date[*]}" )
    if [[ $(( $end_date_in_sec - $start_date_in_sec )) -lt 0 ]]
    then
        output=0
        print_error "5"
    fi
fi

current_date=$(date +%d%m%y)

function clean {
    for file in `sudo find / -maxdepth 1 2> /dev/null`
    do
        if [[ $( compare_name $file ) -eq 1 ]]
        then
            for item in `sudo find $file -newermt "${start_date[2]}-${start_date[1]}-${start_date[0]} ${start_date[3]}:${start_date[4]}:00" -and ! -newermt "${end_date[2]}-${end_date[1]}-${end_date[0]} ${end_date[3]}:${end_date[4]}:00" 2> /dev/null`
            do
                if [[ $item = *"_$current_date"* ]]
                then
                    echo "$item" >> log_remove.txt
                    sudo rm -rf $item
                fi
            done     
        fi
    done
}

if [[ $output -ne 0 ]]
then
    clean
fi
