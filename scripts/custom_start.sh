#!/bin/bash


TOMCAT_BIN_DIR="/opt/tomcat/bin"
STARTUP_SCRIPT="$TOMCAT_BIN_DIR/startup.sh"
LOGS_DIR="/codedeploy/logs"


mkdir -p "$LOGS_DIR"


get_latest_log_file() {
    latest_log=$(ls -t "$LOGS_DIR"/*.log 2>/dev/null | head -n 1)
    echo "$latest_log"
}


latest_log_file=$(get_latest_log_file)
if [ -z "$latest_log_file" ]; then
    log_file="$LOGS_DIR/startup_$(date +"%Y%m%d_%H%M%S").log"
else
    log_file="$latest_log_file"
fi


exec &> >(tee -a "$log_file")


echo "Using log file: $log_file"
echo "================================custom start ========================="
# Start Tomcat using the startup script
echo "Starting Tomcat..."
"$STARTUP_SCRIPT" start


startup_exit_code=$?


sleep 5


echo "Verifying Tomcat status..."
if ps -ef | grep tomcat | grep -v grep; then
    echo "Tomcat is running"
    exit 0
else
    echo "Tomcat is not running or startup failed. Check logs for details."
    exit 1
fi

