#!/bin/bash

# Glances connection script

# Path to the file containing the IP addresses of the servers
CONFIG_FILE="./glances_servers.conf"

# Function to check if the configuration file exists
check_config_file() {
  if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file '$CONFIG_FILE' not found!"
    exit 1
  fi
}

# Function to connect to Glances servers
connect_to_glances_servers() {
  echo "Reading server IPs from configuration file: $CONFIG_FILE"
  SERVERS=()
  
  # Read the IP addresses from the config file
  while IFS= read -r line; do
    # Ignore empty lines and comments
    if [[ ! -z "$line" && ! "$line" =~ ^# ]]; then
      SERVERS+=("$line")
    fi
  done < "$CONFIG_FILE"

  # Check if there are any IPs to connect to
  if [ ${#SERVERS[@]} -eq 0 ]; then
    echo "No valid IP addresses found in the configuration file."
    exit 1
  fi

  # Connect to each Glances server in client mode
  for SERVER in "${SERVERS[@]}"; do
    echo "Connecting to Glances server at $SERVER..."
    glances -c "$SERVER" &
  done
}

# Main function to run the script
main() {
  check_config_file
  connect_to_glances_servers
  echo "Connected to all specified Glances servers!"
}

main
