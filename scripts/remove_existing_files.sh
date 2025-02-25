#!/bin/bash


APP_DIR="/opt/tomcat/webapps"  # Path to your application directory
BACKUP_DIR="/opt/backups"              # Path to backup directory
LOG_DIR="/codedeploy/logs"             # Path to log directory


mkdir -p "$LOG_DIR"


latest_log=$(ls -t "$LOG_DIR"/deployment_log_*.log 2>/dev/null | head -n 1)


if [ -n "$latest_log" ]; then
    echo "Using latest log file: $latest_log"

    
    {
        echo "Starting script execution at $(date)"
        echo "Using latest log file: $latest_log"

        # Check if the application directory exists
        if [ -d "$APP_DIR" ]; then
            echo "=================================== start of remove existing file====================="
            echo "Application directory found: $APP_DIR"

           
            timestamp=$(date +"%Y%m%d_%H%M%S")

            
            backup_folder="$BACKUP_DIR/vicky_$timestamp"
            mkdir -p "$backup_folder"

            echo "Created backup folder: $backup_folder"

            
            echo "Moving application files to backup folder..."
            mv "$APP_DIR/vicky*" "$backup_folder"

           
            if [ $? -eq 0 ]; then
                echo "Previous application files moved successfully"
            else
                echo "Failed to move application files. Exit code: $?"
            fi

          
            echo "Removing .war files from application directory..."
            rm -rf "$APP_DIR"/*.war

           
            if [ $? -eq 0 ]; then
                echo "Removed .war files successfully"
            else
                echo "Failed to remove .war files. Exit code: $?"
            fi
        else
            echo "Application directory not found: $APP_DIR"
        fi

      
        echo "Proceeding with installation of new application..."

        echo "Script execution completed at $(date)"
    } | tee -a "$latest_log"
else
    echo "No log files found in $LOG_DIR"
fi

