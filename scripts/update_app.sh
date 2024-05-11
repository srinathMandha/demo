#!/bin/bash

# Define paths
WEBAPPS_DIR="/opt/tomcat/webapps"        # Path to webapps directory
ARTIFACT_S3_BUCKET="testwar-viky"         # S3 bucket name
ARTIFACT_S3_KEY="Artifacts/Current_deployable_Artifact"  # Path to the artifact in S3
FILE_PATTERN="*.war"                      # File pattern to match
LOGS_DIR="/codedeploy/logs"               # Directory for deployment logs

# Ensure logs directory exists
mkdir -p "$LOGS_DIR"

# Function to find the latest log file in the logs directory
get_latest_log_file() {
    latest_log=$(ls -t "$LOGS_DIR"/*.log 2>/dev/null | head -n 1)
    echo "$latest_log"
}

# Determine the latest log file
latest_log_file=$(get_latest_log_file)

# If no log files exist or the latest log file is not found, create a new log file
if [ -z "$latest_log_file" ]; then
    log_file="$LOGS_DIR/deployment_$(date +"%Y%m%d_%H%M%S").log"
else
    log_file="$latest_log_file"
fi

# Redirect stdout and stderr to the log file
exec &> >(tee -a "$log_file")

# Display log file used for logging
echo "Using log file: $log_file"

# Download artifact from S3 using AWS CLI with logging
echo "Downloading artifact from S3..."
aws s3 cp "s3://$ARTIFACT_S3_BUCKET/$ARTIFACT_S3_KEY" "$WEBAPPS_DIR/" --recursive --exclude "*" --include "$FILE_PATTERN"

# Check if download was successful
if [ $? -eq 0 ]; then
    echo "Artifact downloaded successfully"
else
    echo "Failed to download artifact from S3. Exit code: $?"
    exit 1  # Exit script with error status
fi

# Display paths of downloaded files
echo "Paths of downloaded WAR files:"
find "$WEBAPPS_DIR" -type f -name "$FILE_PATTERN"

# Proceed with deployment tasks (e.g., restarting Tomcat)
echo "Proceeding with deployment tasks..."



