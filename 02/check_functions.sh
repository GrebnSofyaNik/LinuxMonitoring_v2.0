#!/bin/bash

function print_error {
    case $1 in
    1) echo "You need to specify 3 parameters! (1)name_folders (2)name_files (3)file_size" >&2;;
    2) echo "(1)Directory name must be less than 8 characters!" >&2;;
    3) echo "(1)The directory name must contain only letters!" >&2;;
    4) echo "(2)Specify the file extension with a dot!" >&2;;
    5) echo "(2)File name must be less than 8 characters!" >&2;;
    6) echo "(2)The file name must contain only letters!" >&2;;
    7) echo "(2)File extension must be less than 4 characters!" >&2;;
    8) echo "(2)The file extension must contain only letters!" >&2;;
    9) echo "(3)Incorrect size file! [example: 10kb]" >&2;;
    10) echo "(3)Specify the dimension in megabytes! [example: 10Mb]" >&2;;
    11) echo "(3)File size must be greater than 0 and less than 100 kilobytes!" >&2;;
    12) echo "The name must contain unique letters!" >&2;;
    esac
}

function check_num_parameters {
    output=1
    if [[ $1 != 3 ]]
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

function check_characters {
    if [[ $1 =~ ^[a-z]+$ ]]; then
        echo "1"
    else
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
        print_error "12"
        echo "0"
    else
        echo "1"
    fi
}

function check_name_dir {
    length=$(( ${#1}))
    if [[ $length -gt 7 ]]
    then
        print_error "2"
        echo "0"
    elif [[ $( check_characters $1 ) -eq 0 ]]
    then
        print_error "3"
        echo "0"
    elif [[ $( check_uniq_letters $1 ) -eq 0 ]]
    then
        echo "0"
    else
        echo "1"
    fi
}

function check_name_file {
    if [[ $1 != *"."* ]]
    then
        print_error "4"
        echo "0"
    else
        name=($( echo $1 | tr "." "\n" ))
        length=$(( ${#name[0]} ))
        if [[ $length -gt 7 ]]
        then
            print_error "5"
            echo "0"
        elif [[ $( check_characters ${name[0]} ) -eq 0 ]]
        then
            print_error "6"
            echo "0"
        elif [[ $( check_uniq_letters ${name[0]} ) -eq 0 ]]
        then
            echo "0"
        else
            length=$(( ${#name[1]} ))
            if [[ $length -gt 3 ]]
            then
                print_error "7"
                echo "0"
            elif [[ $( check_characters ${name[1]} ) -eq 0 ]]
            then
                print_error "8"
                echo "0"
            else
                echo "1"
            fi
        fi
    fi
}

function check_file_size {
    size=$1
    length=$(( ${#1} ))
    if [[ $length -ge 3 ]]
    then
        if [[ ${size:$length - 2} != "Mb" ]]
        then
            print_error "10"
            echo "0"
        else
            size=${size:0:$length - 2}
            if [[ $( check_number $size ) -eq 0 ]]
            then 
                print_error "9"
                echo "0"
            elif [[ $size -gt 100 ]] || [[ $size -eq 0 ]]
            then
                print_error "11"
                echo "0"
            else
                echo "1"
            fi
        fi
    else
        print_error "10"
        echo "0"
    fi
}
