#!/bin/bash

# Script requires the following environment variables:
# - PRIVATE_KEY: The private key of the boot-operator wallet

# Check the PRIVATE_KEY environment variable exists and exit if it doesn't
if [ -z "$PRIVATE_KEY" ]; then
    echo "PRIVATE_KEY environment variable not set, exiting with error"
    exit 1
fi

# Function to terminate the script and all child processes
terminate_script() {
    pkill -P $$
    exit 1
}

run_sentry_node() {
    expect -c "
    exp_internal 0
    log_user 1
    spawn /usr/local/bin/sentry-node-cli-linux
    expect \"\$\"
    send \"boot-operator\r\"
    expect \"Enter the private key of the operator:\"
    send \"$PRIVATE_KEY\r\"
    expect \"Provisioning http provider.\"
    expect \"Do you want to use a whitelist for the operator runtime\"
    send \"n\r\"
    interact
    "
}

LOG_FILE="/var/log/sentry-node.log"

run_sentry_node | while IFS= read -r line
do
    # Write every line to the log file
    echo "$line" >> "$LOG_FILE"
    # And to the console
    echo "$line"
    
    # Check if the line contains the string 'assertion' and exit the script if it does
    if [[ $line == *"assertion"* ]]; then
        echo "** Sentry node crashed, exiting script **"
        terminate_script
    fi

    # Check if the line indicates 'Fetched 0 node licenses' and exit the script if it does
    if [[ $line == *"Total Sentry Keys fetched: 0"* ]]; then
        echo "** No node licenses found for wallet associated with PRIVATE_KEY, exiting script **"
        echo "** Please ensure the wallet associated with PRIVATE_KEY has a node license **" >> "$LOG_FILE"
        terminate_script
    fi
done
