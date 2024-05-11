#!/bin/bash

# Define paths
APP_DIR="/opt/tomcat/webapps/sample"  # Path to your application directory
BACKUP_DIR="/opt/backups"              # Path to backup directory
LOG_DIR="/codedeploy/logs"             # Path to log directory

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Find the most recently modified log file in the log directory
latest_log=$(ls -t "$LOG_DIR"/log*.txt 2>/dev/null | head -n 1)

# Check if a log file was found
if [ -n "$latest_log" ]; then
    echo "Using latest log file: $latest_log"

    # Execute the backup and removal process
    if [ -d "$APP_DIR" ]; then
        # Generate a timestamp for backup folder name (e.g., YYYYMMDD_HHMMSS)
        timestamp=$(date +"%Y%m%d_%H%M%S")

        # Create a backup folder using the timestamp
        backup_folder="$BACKUP_DIR/sample_$timestamp"
        mkdir -p "$backup_folder"

        # Move contents of the application directory to the backup folder
        mv "$APP_DIR" "$backup_folder"

        echo "Previous application files moved to backup folder: $backup_folder"
        rm -f "$APP_DIR/sample*.war"
    else
        echo "Application directory not found: $APP_DIR"
    fi

    # Continue with other lifecycle steps (e.g., installing new application)
    echo "Proceeding with installation of new application..." | tee -a "$latest_log"
else
    echo "No log files found in $LOG_DIR"
fi
