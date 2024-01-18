#!/bin/bash

. ./check_functions.sh

function get_random {
    echo $(( RANDOM % $2 + $1 ))
}

function get_ip {
    local min=0
    local max=256
    local ip=
    for (( i=0; i < 4; i++))
    do
        ip+="$( get_random $min $max )"
        if [[ $i -ne 3 ]]
        then
            ip+="."
        fi
    done
    echo "$ip"
}

function get_status {
    local status=( "200" "201" "400" "401" "403" "404" "500" "501" "502" "503" )
    local min=0
    local max=10
    num=$( get_random $min $max )
    echo "${status[$num]}"
}

# HTTP status code:
# 200 - OK
# 201 - Created
#       Запрос успешно выполнен и в результате был создан ресурс. Этот код обычно присылается в ответ на запрос PUT
# 400 - Bad Request
#       Этот ответ означает, что сервер не понимает запрос из-за неверного синтаксиса
# 401 - Unauthorized
#       Для получения запрашиваемого ответа нужна аутентификация
# 403 - Forbidden
#       У клиента нет прав доступа к содержимому, поэтому сервер отказывается дать надлежащий ответ
# 404 - Not Found
#       Сервер не может найти запрашиваемый ресурс
# 500 - Internal Server Error ("Внутренняя ошибка сервера")
#       Сервер столкнулся с ситуацией, которую он не знает как обработать
# 501 - Not Implemented
#       Метод запроса не поддерживается сервером и не может быть обработан
# 502 - Bad Gateway
#       Эта ошибка означает что сервер, во время работы в качестве шлюза для получения ответа,
#       нужного для обработки запроса, получил недействительный (недопустимый) ответ
# 503 - Service Unavailable
#       Сервер не готов обрабатывать запрос (или отключен, или перегружен)

function get_method {
    local method=( "GET" "POST" "PUT" "PATCH" "DELETE" )
    local min=0
    local max=5
    num=$( get_random $min $max )
    echo "${method[$num]}"
}

function get_url {
    local min=2
    local max=6
    local url=
    amount_count=$( get_random $min $max )
    for (( i=0; i < amount_count; i++ ))
    do
        url+="$( head -c 100 /dev/urandom | base64 | sed 's/[+=/A-Z]//g' | tail -c $( get_random 5 10 ) )"
        if [[ i -eq 0 ]]
        then
            url+=".com"
        fi
        if [[ i -ne $(( $amount_count - 1 )) ]]
        then
            url+="/"
        fi
    done
    echo "https://$url.html"
}

function get_agent {
    local agent=( "Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool" )
    local min=0
    local max=8
    num=$( get_random $min $max )
    echo "${agent[$num]}"
}

function get_date {
    output=0
    while [[ $output -eq 0 ]]
    do
        day=$( get_random 1 31 )
        month=$( get_random 1 12 )
        year=$( get_random 0 24 )
        output=$( check_days_in_month "$day $month $year" )
    done
    local name_month=( "" "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec" )
    echo "$( printf "%02d" "$day" )/${name_month[$month]}/$(( 2000 + $year ))"
}

function get_time {
    hour=$( get_random 0 24 )
    min=$( get_random 0 60 )
    sec=$( get_random 0 60 )
    echo "$( printf "%02d" "$hour" ):$( printf "%02d" "$min" ):$( printf "%02d" "$sec" )"
}