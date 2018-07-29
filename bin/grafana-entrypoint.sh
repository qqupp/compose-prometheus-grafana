#!/usr/bin/env bash

getArg() {
    file="$1"
    search="$2"
    grep "$search" "$file" | head -1 | awk '{print $3}'
}

getBasicAuth() {
    confFile=/etc/grafana/grafana.ini
    admin=$(getArg $confFile admin_user)
    password=$(getArg $confFile admin_password)
    echo -n "${admin}:${password}" | base64
}

setUpPrometheusDatasource() {
    basicAuth=$(getBasicAuth)
    
    curl 'http://localhost:3000/api/datasources' \
	 -X POST \
	 -H 'Content-Type: application/json;charset=UTF-8' \
	 -H "Authorization: Basic $basicAuth" \
	 --data-binary \
	 '{"name":"Prometheus","type":"prometheus","url":"http://prometheus:9090","access":"proxy","isDefault":true}'
}


echo 'Starting Grafana...'
/run.sh "$@" &

sleep 5

until setUpPrometheusDatasource; do
    echo 'Configuring Grafana...'
    sleep 2
done

echo 'Grafana ready.'
wait
