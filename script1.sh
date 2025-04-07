#!/bin/bash

# Enable error handling
set -e

# Check if more than one argument is passed
if [ "$#" -gt 1 ]; then
    echo "ERROR: Only one argument is allowed."
    exit 1
fi

# Checks if the user provided a filename
if [ -z "$1" ]; then
    read -p "Enter the name of the file you wish to create a backup of: " fileName
else
    fileName="$1"
fi

# Checks if the file exists
if [ -f "$fileName" ]; then
    # Creates a .bak file
    cp "$fileName" "$fileName.bak"

    # Checks if backup_log.txt exists
    if [ ! -f "backup_log.txt" ]; then
        touch backup_log.txt
        echo "Backup log file created."
    fi

    # creates a timestamp log in the backup_log.txt
    echo "Backup of \"$fileName\" created on $(date)" >> backup_log.txt

    # Counts the number of lines in the backup log
    lineCount=$(wc -l < backup_log.txt)

    # Checks if the line count exceeds 5
    if [ "$lineCount" -gt 5 ]; then
        # Remove the first (oldest) line and update the log file
        tail -n +2 backup_log.txt > temp_log.txt
        mv temp_log.txt backup_log.txt
        echo "Oldest backup log entry deleted."
    fi

else
    echo "ERROR: \"$fileName\" does not exist."
fi

