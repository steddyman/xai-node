#!/bin/bash

# Define the log file and the timeout
LOG_FILE="/var/log/sentry-node.log"
TIMEOUT=600 # 10 minutes in seconds

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found."
    exit 1
fi

# Get the last modification time of the log file in Unix epoch time
LAST_MOD_TIME=$(stat -c %Y "$LOG_FILE")

# Get the current time
CURRENT_TIME=$(date +%s)

# Calculate the time difference
TIME_DIFF=$(( CURRENT_TIME - LAST_MOD_TIME ))

# Check if the last log entry is older than the timeout
if [ $TIME_DIFF -gt $TIMEOUT ]; then
    echo "The application has not logged anything in the last 10 minutes."
    exit 1
else
    echo "The application is logging as expected."
    exit 0
fi
