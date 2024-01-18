#!/bin/bash

. ./check_functions.sh

echo -n "Enter name mask [abc_DDMMYY]: "
read answer

function check_mask {
    if [[ $( echo "$1" | grep -E "^[a-z]+_[0-9]+$") ]]
    then
        IFS='_' read -ra input_mask <<< "$1"
        symbols=${input_mask[0]}
        input_date=${input_mask[1]}
        output=$( check_uniq_letters $symbols )
        echo "$symbols $input_date"
    else
        print_error "6"
    fi
}

mask=($( check_mask "$answer" ))

if [[ ${#mask[@]} -ne 0 ]]
then
    output=$( check_uniq_letters $symbols )
else 
    output=0
fi

if [[ output -eq 1 ]]
then
    if [[ ${#mask[1]} -eq 6 ]]
    then
        day=${mask[1]:0:2}
        month=${mask[1]:2:2}
        year=${mask[1]:4:2}
        output=$( check_input_date "$day $month $year 00 00" )
    else
        print_error "6"
    fi
fi

function get_name {
    name=($( echo $1 | fold -w1 ))
    for char in ${name[@]}
    do
        mask_name+=$char
        mask_name+="+"
    done
    echo $mask_name
}

function clean {
    for item in `sudo find / -regextype posix-extended -regex ".*/${mask_name}_${mask[1]}" 2> /dev/null`
    do
        echo "$item" >> log_remove.txt
        sudo rm -rf $item
    done    
}

if [[ $output -eq 1 ]]
then
    mask_name=$( get_name ${mask[0]} )
    clean
fi