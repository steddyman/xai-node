#!/bin/bash

# Define the log file and the timeout
LOG_FILE="/var/log/sentry-node.log"
TIMEOUT=600 # 10 minutes in seconds

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found."
    exit 1
fi

# Extract the last log entry's timestamp and convert it into a format that 'date' understands
LAST_LOG_ENTRY=$(tail -n 1 "$LOG_FILE")
LAST_LOG_TIME=$(echo $LAST_LOG_ENTRY | awk -F '[][]' '{print $2}' | sed 's/T/ /; s/Z//')

# Convert the timestamp to Unix epoch time
LAST_LOG_TIME=$(date -d "$LAST_LOG_TIME" +%s 2>/dev/null)
echo "Last Log Time: $LAST_LOG_TIME"

# Check if the last log time could be determined
if [ -z "$LAST_LOG_TIME" ]; then
    echo "Could not determine the time of the last log entry."
    exit 1
fi

# Get the current time
CURRENT_TIME=$(date +%s)

# Calculate the time difference
TIME_DIFF=$(( CURRENT_TIME - LAST_LOG_TIME ))

# Check if the last log entry is older than the timeout
if [ $TIME_DIFF -gt $TIMEOUT ]; then
    echo "The application has not logged anything in the last 5 minutes."
    exit 1
else
    echo "The application is logging as expected."
    exit 0
fi
