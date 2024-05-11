#!/bin/bash

# Directory for log files
LOG_DIR="/codedeploy/logs"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Find latest log file number
latest_log=$(ls -v "$LOG_DIR" | grep -E 'deployment_log_[0-9]+' | tail -n 1)
latest_number=0

if [[ "$latest_log" =~ log([0-9]+).txt ]]; then
    latest_number="${BASH_REMATCH[1]}"
fi

# Increment the number for the new log file
next_number=$((latest_number + 1))

# Create new log file with incremented number
new_log_file="$LOG_DIR/deployment_log_${next_number}.log"
touch "$new_log_file"

echo "New log file created: $new_log_file"

# Function to check if Tomcat is running
function is_tomcat_running() {
    ps -ef | grep tomcat | grep -v grep >/dev/null
}

# Redirect stdout to both screen and log file
exec > >(tee -a "$new_log_file")  # Redirect stdout to append to log file
exec 2>&1  # Redirect stderr to stdout
echo  "====================================== start of shutdown ==========================="
echo "Initiating Tomcat shutdown loop..."

# Check if Tomcat is running initially
if ! is_tomcat_running; then
    echo "Tomcat is not running. Exiting script."
    exit 0
fi

# Infinite loop to continuously monitor Tomcat status
while :
do
    # Check if Tomcat is running
    if is_tomcat_running; then
        echo "Tomcat is running. Initiating shutdown..."

        # Trigger the shutdown script
        /opt/tomcat/bin/shutdown.sh

        # Wait briefly before rechecking Tomcat status
        sleep 5

        # Check if Tomcat has stopped after shutdown
        if is_tomcat_running; then
            echo "Tomcat did not stop successfully. Retrying..."
        else
            echo "Shutdown completed. Tomcat is not running."
            break  # Exit the loop once Tomcat has stopped
        fi
    else
        echo "Tomcat is not running. Waiting for Tomcat to start..."
    fi

    # Adjust sleep interval as needed to control loop frequency
    sleep 10
done

echo "Tomcat shutdown loop completed."

