#!/bin/bash

if [[ $# -ne 0 ]]
then
    echo "The script should run without parameters!" >&2
    exit 1
fi

sudo apt install -y nginx

chmod +x get_info.sh

. ./get_info.sh

sudo cp ./.conf/nginx.conf /etc/nginx/nginx.conf
sudo nginx -s reload

sudo cp index.html /usr/share/nginx/html/index.html

sudo cp ./.conf/prometheus.yml /etc/prometheus/prometheus.yml
sudo systemctl restart prometheus.service

echo "Processing..." >&2

while sleep 3
do
    ./get_info.sh
    sudo cp index.html /usr/share/nginx/html/index.html
done
