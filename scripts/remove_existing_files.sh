#!/bin/bash

# Define paths
APP_DIR="/opt/tomcat/webapps"  # Path to your application directory
BACKUP_DIR="/opt/backups"              # Path to backup directory
LOG_DIR="/codedeploy/logs"             # Path to log directory

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Find the most recently modified log file in the log directory
latest_log=$(ls -t "$LOG_DIR"/deployment_log_*.log 2>/dev/null | head -n 1)

# Check if a log file was found
if [ -n "$latest_log" ]; then
    echo "Using latest log file: $latest_log"

    # Redirect all script output to both terminal and the latest log file
    {
        echo "Starting script execution at $(date)"
        echo "Using latest log file: $latest_log"

        # Check if the application directory exists
        if [ -d "$APP_DIR" ]; then
            echo "=================================== start of remove existing file====================="
            echo "Application directory found: $APP_DIR"

            # Generate a timestamp for backup folder name (e.g., YYYYMMDD_HHMMSS)
            timestamp=$(date +"%Y%m%d_%H%M%S")

            # Create a backup folder using the timestamp
            backup_folder="$BACKUP_DIR/sample_$timestamp"
            mkdir -p "$backup_folder"

            echo "Created backup folder: $backup_folder"

            # Move contents of the application directory to the backup folder
            echo "Moving application files to backup folder..."
            mv "$APP_DIR/sample" "$backup_folder"

            # Check if move operation was successful
            if [ $? -eq 0 ]; then
                echo "Previous application files moved successfully"
            else
                echo "Failed to move application files. Exit code: $?"
            fi

            # Remove any remaining .war files
            echo "Removing .war files from application directory..."
            rm -rf "$APP_DIR"/*.war

            # Check if removal was successful
            if [ $? -eq 0 ]; then
                echo "Removed .war files successfully"
            else
                echo "Failed to remove .war files. Exit code: $?"
            fi
        else
            echo "Application directory not found: $APP_DIR"
        fi

        # Continue with other lifecycle steps (e.g., installing new application)
        echo "Proceeding with installation of new application..."

        echo "Script execution completed at $(date)"
    } | tee -a "$latest_log"
else
    echo "No log files found in $LOG_DIR"
fi

