#!/bin/bash

path=$1
length=$(( ${#path} - 1 ))
if [[ ${path:$length} != "/" ]]
then
    path="$path/"
fi

num_folders=$2
name_folder=$3

letters_folder=($( echo $name_folder | fold -w1 | uniq ))
length_letters_folder=${#letters_folder[@]}

array_folder=()
for (( i=0; i < length_letters_folder; i++ ))
do
   array_folder[$i]=1
done

num_files=$4

IFS='.' read -ra name <<< "$5"
name_file=${name[0]}
file_extension=${name[1]}

letters_file=($( echo $name_file | fold -w1 | uniq ))
length_letters_file=${#letters_file[@]}

array_file=()
for (( i=0; i < length_letters_file; i++ ))
do
   array_file[$i]=1
done

size=$6
length=${#size}
file_size=${size:0:length - 2}
bytes=${size:length - 2}

size_disk=$( sudo df -BG / | grep / | awk '{ print $4 }' | sed s/"G"//g )

function random {
    echo $(( $RANDOM % 100 + 1 ))
}

function sum_array {
    local arr=( $@ )
    len=${#arr[@]}
    sum=0
    for (( i=0; i < len; i++ ))
    do
        sum=$(( $sum + ${arr[$i]} ))
    done
    echo $sum
}

function iter_array {
    arr=( $@ )
    count=${#arr[@]}
    iter=1
    for (( i=0; i < count; i++ ))
    do
        if [[ $(( $( sum_array ${arr[@]} ) + $iter )) -gt 244 ]]
        then
            arr[$i]=1
            continue
        else
            arr[$i]=$(( ${arr[$i]} + $iter ))
            iter=0
        fi
    done
    echo "${arr[@]}"
}

function create_name_file {
    arr=( $@ )
    count=${#arr[@]}
    for (( i=0; i < count; i++ ))
    do  
        string=$( printf "%${arr[$i]}c" "${letters_file[$i]}" | sed s/" "/${letters_file[$i]}/g )
        result+=$string
    done
    echo "$result"
}

function create_name_folder {
    arr=( $@ )
    count=${#arr[@]}
    for (( i=0; i < count; i++ ))
    do  
        string=$( printf "%${arr[$i]}c" "${letters_folder[$i]}" | sed s/" "/${letters_folder[$i]}/g )
        result+=$string
    done
    echo "$result"
}

current_date=$(date +%d%m%y)

function create_files {
    input_path=$1
    count=$( random )
    while [[ count -gt 0 ]] && [[ $size_disk -gt 1 ]]
    do
        if [[ -f "${input_path}${name_file}_${current_date}.${file_extension}" ]] || [[ $( sum_array ${array_file[@]} ) -lt 4 ]]
        then
            array_file=($( iter_array ${array_file[@]} ))
            name_file=$( create_name_file ${array_file[@]} )
            continue
        else
            sudo dd if=/dev/zero of="${input_path}${name_file}_${current_date}.${file_extension}"  bs="${file_size}MB"  count=1 status=none
            echo -e "${input_path}${name_file}_${current_date}.${file_extension}\t$(date +%d.%m.%Y)\t${file_size}Mb" >> ../01/log.txt
            array_file=($( iter_array ${array_file[@]} ))
            name_file=$( create_name_file ${array_file[@]} )
            count=$(( $count - 1 ))
            size_disk=$( sudo df -BG / | grep / | awk '{ print $4 }' | sed s/"G"//g )
        fi
    done
}

while [[ num_folders -gt 0 ]] && [[ $size_disk -gt 1 ]]
do
    if [[ -d "${path}${name_folder}_${current_date}" ]] || [[ $( sum_array ${array_folder[@]} ) -lt 4 ]]
    then
        array_folder=($( iter_array ${array_folder[@]} ))
        name_folder=$( create_name_folder ${array_folder[@]} )
        continue
    else
        sudo mkdir "${path}${name_folder}_${current_date}"
        echo -e "${path}${name_folder}_${current_date}\t$(date +%d.%m.%Y)" >> ../01/log.txt
        create_files "${path}${name_folder}_${current_date}/"
        array_folder=($( iter_array ${array_folder[@]} ))
        name_folder=$( create_name_folder ${array_folder[@]} )
        num_folders=$(( $num_folders - 1 ))
        size_disk=$( sudo df -BG / | grep / | awk '{ print $4 }' | sed s/"G"//g )
    fi
done
