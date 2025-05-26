#!/bin/bash

LOGFILE="/var/log/monitoring.log"
MONITORING_URL="https://test.com/monitoring/test/api"
PROCESS_NAME="test_em.sh"
STATE_FILE="/tmp/test_state"

is_process_running() {
        if pgrep -x "$PROCESS_NAME" > /dev/null; then
                echo "$PROCESS_NAME is running"
                return 0
        else
                echo "$PROCESS_NAME is not running"
                return 1
        fi
}

log_message() {
        echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOGFILE"
}

notify_monitoring_server() {
        local response
        response=$(curl -s -o /dev/null -w "%{http_code}" "$MONITORING_URL")
        if [[ "$response" -ne 200 ]]; then
                log_message "Server is not available (HTTP $response)"
        fi
}

if is_process_running; then
        if [[ ! -f "$STATE_FILE" ]]; then
                touch "$STATE_FILE"
                log_message "$PROCESS_NAME was reload"
        fi
        notify_monitoring_server
else
        rm -f "$STATE_FILE"
fi