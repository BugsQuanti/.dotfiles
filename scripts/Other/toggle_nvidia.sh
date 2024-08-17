#!/bin/bash

# File to be checked and modified
CMDLINE_FILE="/etc/kernel/cmdline"

# Entry to check for
ENTRY="module_blacklist=nvidia"

# Function to check if the entry exists in the file
function contains_entry {
    grep -q "$ENTRY" "$CMDLINE_FILE"
}

# Backup the file before making changes
#cp "$CMDLINE_FILE" "${CMDLINE_FILE}.bak"

# Show current status
if contains_entry; then
    echo "Current status: '$ENTRY' is present in $CMDLINE_FILE."
else
    echo "Current status: '$ENTRY' is not present in $CMDLINE_FILE."
fi

# Ask the user what they want to do
read -p "Would you like to toggle the entry? (y/n): " choice

case $choice in
    y|Y)
        if contains_entry; then
            # Entry exists, remove it
            sed -i "s/\b$ENTRY\b//g" "$CMDLINE_FILE"
            # Clean up any leading/trailing whitespaces
            sed -i 's/^[ \t]*//;s/[ \t]*$//' "$CMDLINE_FILE"
            echo "Entry '$ENTRY' has been removed."
        else
            # Entry does not exist, add it
            echo -n " $ENTRY" >> "$CMDLINE_FILE"
            # Clean up any leading whitespaces
            sed -i 's/^[ \t]*//;s/[ \t]*$//' "$CMDLINE_FILE"
            echo "Entry '$ENTRY' has been added."
        fi
        ;;
    n|N)
        echo "No changes made."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Refresh the systemd-boot loader
#bootctl update

# Reinstall kernels
reinstall-kernels

echo "Script completed."
