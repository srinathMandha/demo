#!/bin/bash
set -xe

# Check if deployment ID argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <deployment_id>"
    exit 1
fi

DEPLOYMENT_ID="123"
LOG_FILE="/var/log/deploy_script_${DEPLOYMENT_ID}.log"

# Redirect stdout and stderr to the logfile
exec > >(tee -a "$LOG_FILE") 2>&1

# Output deployment ID for logging
echo "Deployment ID: ${DEPLOYMENT_ID}"

# Delete the old directory as needed
if [ -d /codedeploy ]; then
    rm -rf /codedeploy
fi

# Create new directory /codedeploy
mkdir -vp /codedeploy
