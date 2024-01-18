#!/bin/bash

START=$( date +%H:%M:%S)
echo "$START Start script" >&2
echo "$START Start script" >> ../01/log.txt

name_folder=$1
name_file=$2
file_size=$3

path="/"

current_date=$(date +%d%m%y)

function random {
    echo $(( $RANDOM % 100 + 1 ))
}

function compare_name {
    name=$1
    if [[ $name = *"/bin"* ]] || [[ $name = *"/sbin"* ]] || 
        [[ $name = *"/boot"* ]] || [[ $name = *"/dev"* ]] || 
        [[ $name = *"/proc"* ]] || [[ $name = *"/sys"* ]] || 
        [[ $name = *".git"* ]] || [[ $name = *"/run"* ]] || 
        [[ $name = *"/snap"* ]] || [[ $name = *"/root"* ]] ||
        [[ $name = *"_$current_date"* ]]
    then
        echo "0"
    else
        echo "1"
    fi
}

echo "Processing..." >&2

for dir in `sudo find $path -type d 2> /dev/null`
do
    if [[ $( compare_name $dir ) -eq 1 ]]
    then
        num_folders=$( random )
        num_files=$( random )
        ./create_files.sh $dir $num_folders $name_folder $num_files $name_file $file_size
        size_disk=$( sudo df -BG / | grep / | awk '{ print $4 }' | sed s/"G"//g )
    fi
    if [[ $size_disk -le 1 ]]
    then
        break
    fi
done

END=$( date +%H:%M:%S )
echo "$END End script" >&2
echo "$END End script" >> ../01/log.txt
TOTAL="$(( $( date +%s -d $END ) - $( date +%s -d $START ) ))"
MIN=$( expr $TOTAL / 60 )
SEC=$(( $TOTAL - $MIN * 60 ))
echo "Total script running time $( printf "%02d" $MIN ):$( printf "%02d" $SEC )" >&2
echo "Total script running time $( printf "%02d" $MIN ):$( printf "%02d" $SEC )" >> ../01/log.txt
