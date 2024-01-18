#!/bin/bash

rm -f ./index.html
touch index.html

exec 1>./index.html

cpu1=$( top -b | head -3 | tail +3  | awk '{ print $2 }' | sed 's/,/./' )
cpu2=$( top -b | head -3 | tail +3  | awk '{ print $4 }' | sed 's/,/./' )

cpu=$( echo "$cpu1 + $cpu2" | bc )

echo -e "# HELP cpu_usage CPU usage.\n"
echo -e "# TYPE cpu_usage gauge\n"
echo -e "cpu_usage $cpu\n"

mem_size=$(( $( sudo df | grep -w / | awk '{ print $2 }' ) * 1000 ))
echo -e "# HELP mem_size Memory size.\n"
echo -e "# TYPE mem_size gauge\n"
echo -e "mem_size $mem_size\n"

mem_used=$(( $( sudo df | grep -w / | awk '{ print $3 }' ) * 1000 ))
echo -e "# HELP mem_used Memory used\n"
echo -e "# TYPE mem_used gauge\n"
echo -e "mem_used $mem_used\n"

mem_free=$(( $( sudo df | grep -w / | awk '{ print $4 }' ) * 1000 ))
echo -e "# HELP mem_free Memory free\n"
echo -e "# TYPE mem_free gauge\n"
echo -e "mem_free $mem_free"

ram_used=$(( $( sudo free | grep Mem | awk '{ print $3 }' ) * 1000 ))
echo -e "# HELP ram_used RAM used\n"
echo -e "# TYPE ram_used gauge\n"
echo -e "ram_used $ram_used\n"
