#!/bin/bash

# Directory for log files
LOG_DIR="/codedeploy/logs"


mkdir -p "$LOG_DIR"


latest_log=$(ls -v "$LOG_DIR" | grep -E 'deployment_log_[0-9]+' | tail -n 1)
latest_number=0

if [[ "$latest_log" =~ log([0-9]+).txt ]]; then
    latest_number="${BASH_REMATCH[1]}"
fi


next_number=$((latest_number + 1))

new_log_file="$LOG_DIR/deployment_log_${next_number}.log"
touch "$new_log_file"

echo "New log file created: $new_log_file"


function is_tomcat_running() {
    ps -ef | grep tomcat | grep -v grep >/dev/null
}

exec > >(tee -a "$new_log_file")  # Redirect stdout to append to log file
exec 2>&1  # Redirect stderr to stdout
echo  "====================================== start of shutdown ==========================="
echo "Initiating Tomcat shutdown loop..."


if ! is_tomcat_running; then
    echo "Tomcat is not running. Exiting script."
    exit 0
fi


while :
do
   
    if is_tomcat_running; then
        echo "Tomcat is running. Initiating shutdown..."

       
        /opt/tomcat/bin/shutdown.sh

        
        sleep 5


        if is_tomcat_running; then
            echo "Tomcat did not stop successfully. Retrying..."
        else
            echo "Shutdown completed. Tomcat is not running."
            break  # Exit the loop once Tomcat has stopped
        fi
    else
        echo "Tomcat is not running. Waiting for Tomcat to start..."
    fi

    sleep 10
done

echo "Tomcat shutdown loop completed."

