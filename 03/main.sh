#!/bin/bash

chmod +x check_functions.sh

. ./check_functions.sh

check=$( check_num_parameters $# )

if [[ $check -eq 1 ]]
then
    check=$( check_parameter $1 )
fi

chmod +x clean_log_file.sh
chmod +x clean_date_and_time.sh
chmod +x clean_mask_name.sh

function selector {
    case $1 in
        1) ./clean_log_file.sh;;
        2) ./clean_date_and_time.sh;;
        3) ./clean_mask_name.sh;;
    esac
}

if [[ $check -eq 1 ]]
then
    selector $1
fi
