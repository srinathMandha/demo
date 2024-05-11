#!/bin/bash
set -xe


# Delete the old directory as needed
if [ -d /codedeploy ]; then
    rm -rf /codedeploy
fi

# Create new directory /codedeploy
mkdir -vp /codedeploy
