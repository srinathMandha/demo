#!/bin/bash

# Define paths
APP_DIR="/opt/tomcat/webapps/sample"  # Path to your application directory
BACKUP_DIR="/opt/backups"        # Path to backup directory

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Check if the application directory exists
if [ -d "$APP_DIR" ]; then
    # Generate a timestamp for backup folder name (e.g., YYYYMMDD_HHMMSS)
    timestamp=$(date +"%Y%m%d_%H%M%S")

    # Create a backup folder using the timestamp
    backup_folder="$BACKUP_DIR/sample_$timestamp"
    mkdir -p "$backup_folder"

    # Move contents of the application directory to the backup folder
    mv "$APP_DIR" "$backup_folder/"

    echo "Previous application files moved to backup folder: $backup_folder"
    rm -rf sample*.war
else
    echo "Application directory not found: $APP_DIR"
fi

# Continue with other lifecycle steps (e.g., installing new application)
echo "Proceeding with installation of new application..."

