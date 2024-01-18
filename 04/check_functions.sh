#!/bin/bash

function print_error {
    case $1 in
    1) echo "The script should run without parameters!" >&2;;
    esac
}

function check_num_parameters {
    output=1
    if [[ $1 != 0 ]]
    then
        print_error "1"
        echo "0"
    else
        echo "1"
    fi
}

days_in_month=( "0" "31" "28" "31" "30" "31" "30" "31" "31" "30" "31" "30" "31" )

function check_days_in_month {
    input_date=( $1 )
    if [[ $( expr ${input_date[2]} % 4 ) -eq 0 ]] && [[ ${input_date[1]} -eq 2 ]]
    then
        max_days=$(( ${days_in_month[2]} + 1 ))
    else
        max_days="${days_in_month[${input_date[1]}]}"
    fi
    if [[ ${input_date[0]} -le $max_days ]]
    then
        echo "1"
    else
        echo "0"
    fi
}
