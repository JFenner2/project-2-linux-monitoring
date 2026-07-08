#!/bin/bash

URL="http://localhost"
LOGFILE="/home/ubuntu/monitoring/healthcheck.log"
STATEFILE="/home/ubuntu/monitoring/healthcheck.state"
CONTAINER="project2-nginx"
SNS_TOPIC="arn:aws:sns:us-east-1:118178009894:project2-alerts"
HOSTNAME=$(hostname)

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")


send_alert() {

MESSAGE="
Project 2 Monitoring Alert

Host: $HOSTNAME
Time: $TIMESTAMP

Status Change:
$PREVIOUS_STATUS -> $CURRENT_STATUS

Container:
$CONTAINER

HTTP Status:
$HTTP_STATUS
"

aws sns publish \
--topic-arn "$SNS_TOPIC" \
--subject "Project 2 Monitoring Alert" \
--message "$MESSAGE"

}


CONTAINER_STATUS=$(sudo docker inspect -f '{{.State.Running}}' $CONTAINER 2>/dev/null)


if [ "$CONTAINER_STATUS" != "true" ]; then

    CURRENT_STATUS="UNHEALTHY - CONTAINER DOWN"
    HTTP_STATUS="N/A"

else

    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)

    if [ "$HTTP_STATUS" -eq 200 ]; then
        CURRENT_STATUS="HEALTHY"
    else
        CURRENT_STATUS="UNHEALTHY - HTTP FAILURE"
    fi

fi


if [ -f "$STATEFILE" ]; then
    PREVIOUS_STATUS=$(cat "$STATEFILE")
else
    PREVIOUS_STATUS="UNKNOWN"
fi


if [ "$CURRENT_STATUS" != "$PREVIOUS_STATUS" ]; then

    echo "[$TIMESTAMP] STATUS CHANGE: $PREVIOUS_STATUS -> $CURRENT_STATUS (HTTP $HTTP_STATUS)" >> "$LOGFILE"

    send_alert

fi


echo "$CURRENT_STATUS" > "$STATEFILE"
