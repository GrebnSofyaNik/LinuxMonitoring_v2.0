#!/bin/bash

chmod +x check_functions.sh

. ./check_functions.sh

parameters=( $@ )

check=$( check_num_parameters $# )

if [[ $check -eq 1 ]]
then
    check=$( check_name_dir ${parameters[0]} )
fi

if [[ $check -eq 1 ]]
then
    check=$( check_name_file ${parameters[1]} )
fi

if [[ $check -eq 1 ]]
then
    check=$( check_file_size ${parameters[2]} )
fi

chmod +x preparation.sh

if [[ $check -eq 1 ]]
then
    ./preparation.sh $@
fi
