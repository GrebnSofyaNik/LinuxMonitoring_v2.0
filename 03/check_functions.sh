#!/bin/bash

function print_error {
    case $1 in
    1) echo "You need to specify 1 parameter! 1-log_file 2-date and time 3-mask name" >&2;;
    2) echo "Parameter must be a number from 1 to 3!" >&2;;
    3) echo "Log-file does not exist!" >&2;;
    4) echo "Incorrect date [example: DD.MM.YY HH:MM]!" >&2;;
    5) echo "Incorrect end date!" >&2;;
    6) echo "Incorrect name mask!" >&2;;
    7) echo "The name must contain unique letters!" >&2;;
    esac
}

function compare_name {
    name=$1
    if [[ $name = *"/bin"* ]] || [[ $name = *"/sbin"* ]] || 
        [[ $name = *"/boot"* ]] || [[ $name = *"/dev"* ]] || 
        [[ $name = *"/proc"* ]] || [[ $name = *"/sys"* ]] || 
        [[ $name = *".git"* ]] || [[ $name = *"/run"* ]] || 
        [[ $name = *"/snap"* ]] || [[ $name = *"/root"* ]] ||
        [[ $name = "/" ]]
    then
        echo "0"
    else
        echo "1"
    fi
}

function check_num_parameters {
    output=1
    if [[ $1 != 1 ]]
    then
        print_error "1"
        echo "0"
    else
        echo "1"
    fi
}

function check_number {
    if [[ $1 =~ ^[0-9]+$ ]]; then
        echo "1"
    else
        echo "0"
    fi
}

function check_parameter {
    if [[ $( check_number $1 ) -eq 1 ]] && [[ $1 -gt 0 ]] && [[ $1 -lt 4 ]]
    then
        echo "1"
    else
        print_error "2"
        echo "0"
    fi
}

days_in_month=( "0" "31" "28" "31" "30" "31" "30" "31" "31" "30" "31" "30" "31" )

function check_day {
    if [[ $(( 10#$1 )) -gt 0 ]] && [[ $(( 10#$1 )) -le 31 ]]
    then
        echo "1"
    else
        echo "0"
    fi
}

function check_month {
    if [[ $(( 10#$1 )) -gt 0 ]] && [[ $(( 10#$1 )) -le 12 ]]
    then
        echo "1"
    else
        echo "0"
    fi
}

function check_year {
    if [[ $(( 10#$1 )) -ge 0 ]] && [[ $(( 10#$1 )) -le 99 ]]
    then
        echo "1"
    else
        echo "0"
    fi
}

function check_hour {
    if [[ $(( 10#$1 )) -ge 0 ]] && [[ $(( 10#$1 )) -le 24 ]]
    then
        echo "1"
    else
        echo "0"
    fi
}

function check_min {
    if [[ $(( 10#$1 )) -ge 0 ]] && [[ $(( 10#$1 )) -le 59 ]]
    then
        echo "1"
    else
        echo "0"
    fi
}

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

function check_input_date {
    input_date=( $1 )
    if [[ $( check_day ${input_date[0]} ) -eq 1 ]] && [[ $( check_month ${input_date[1]} ) -eq 1 ]] && 
    [[ $( check_year ${input_date[2]} ) -eq 1 ]] && [[ $( check_hour ${input_date[3]} ) -eq 1 ]] && 
    [[ $( check_min ${input_date[4]} ) -eq 1 ]]
    then
        if [[ $( check_days_in_month "${input_date[0]} ${input_date[1]} ${input_date[2]}" ) -eq 1 ]]
        then
            echo "1"
        else
            print_error "4"
            echo "0"
        fi
    else
        print_error "4"
        echo "0"
    fi
}

function check_uniq_letters {
    name=$1
    letters=($( echo $name | fold -w1 | uniq ))
    num_letters=${#letters[@]}
    length=${#name}
    if [[ $num_letters -ne $length ]]
    then
        print_error "7"
        echo "0"
    else
        echo "1"
    fi
}
