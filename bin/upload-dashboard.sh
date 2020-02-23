#!/usr/bin/env bash

# get one from http://localhost:3000/org/apikeys
GRAFANA_TOKEN=eyJrIjoiRUJDSXlOZmhRUDBVTTdKVUp6cEpldEd2cXBKOTFQNHkiLCJuIjoic2FkZmFzZGYiLCJpZCI6MX0=

BASE_URI="localhost:3000"


function query_grafana {
    local VERB="$1"
    local GRAFANA_PATH="$2"
    local BODY="${3:-}"

    local BODY_ARGS=""
    if [[ -n "$BODY" ]]; then
        BODY_ARGS="-d${BODY}"
    fi

    echo $(curl -s -H 'Content-Type: application/json' --write-out 'HTTPSTATUS:%{http_code}' -X "$VERB" -H "Authorization: Bearer $GRAFANA_TOKEN" "${BODY_ARGS}" "$BASE_URI$GRAFANA_PATH")
}


function post_dashboard {
    local BODY="$1"
    local HTTP_RESPONSE=$(query_grafana 'POST' "/api/dashboards/db" "$BODY")

    echo $HTTP_RESPONSE
}


post_dashboard "$(cat "$1")"