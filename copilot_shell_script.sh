#!/bin/bash

# Prompt user for new assignment name
read -p "Enter the new assignment name: " newAssignment

# Find the main directory (assuming it follows the naming pattern)
mainDir=$(find . -type d -name "submission_reminder_*" | tail -n 1)

if [ -z "$mainDir" ]; then
    echo "Error: Could not find the submission_reminder directory."
    exit 1
fi

# Update the config.env file
configFile="${mainDir}/config/config.env"

# Use sed to update the ASSIGNMENT value
sed -i "s/ASSIGNMENT=.*/ASSIGNMENT=\"${newAssignment}\"/" "$configFile"

echo "Assignment updated to: ${newAssignment}"
echo "Rerunning the reminder application..."

# Run the startup script
(cd "$mainDir" && bash startup.sh)
