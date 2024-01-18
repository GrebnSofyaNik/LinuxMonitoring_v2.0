#!/bin/bash

files="../04/1.log ../04/2.log ../04/3.log ../04/4.log ../04/5.log"

function code_sorting {
    rm -f code_sorting.txt
    awk '{ print $0 }' $files | sort -k 8 >> code_sorting.txt
}

function all_uniq_ip {
    rm -f all_uniq_ip.txt
    awk '{ print $1 }' $files | uniq | sort >> all_uniq_ip.txt
}

function error_code {
    rm -f error_code.txt
    awk '{ if ($8 >= 400) print $6,$7,$8 }' $files | sort -k 3  >> error_code.txt
}

function error_uniq_ip {
    rm -f error_uniq_ip.txt
    awk '{ if ($8 >= 400) print $1,$8 }' $files | uniq | sort -k 1 >> error_uniq_ip.txt
}
