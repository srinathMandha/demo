#!/bin/bash

# Define paths
WEBAPPS_DIR="/opt/tomcat/webapps"        
ARTIFACT_S3_BUCKET="testwar-viky"        
ARTIFACT_S3_KEY="Artifacts/Current_deployable_Artifact"
FILE_PATTERN="*.war"
LOGS_DIR="/codedeploy/logs"           


mkdir -p "$LOGS_DIR"


get_latest_log_file() {
    latest_log=$(ls -t "$LOGS_DIR"/*.log 2>/dev/null | head -n 1)
    echo "$latest_log"
}


latest_log_file=$(get_latest_log_file)

if [ -z "$latest_log_file" ]; then
    log_file="$LOGS_DIR/deployment_$(date +"%Y%m%d_%H%M%S").log"
else
    log_file="$latest_log_file"
fi


exec &> >(tee -a "$log_file")


echo "Using log file: $log_file"


echo "=============================================== startof update_app.sh======================"
echo "Downloading artifact from S3..."
aws s3 cp "s3://$ARTIFACT_S3_BUCKET/$ARTIFACT_S3_KEY" "$WEBAPPS_DIR/" --recursive --exclude "*" --include "$FILE_PATTERN"


if [ $? -eq 0 ]; then
    echo "Artifact downloaded successfully"
else
    echo "Failed to download artifact from S3. Exit code: $?"
    exit 1  # Exit script with error status
fi

echo "Paths of downloaded WAR files:"
find "$WEBAPPS_DIR" -type f -name "$FILE_PATTERN"

echo "Proceeding with deployment tasks..."



