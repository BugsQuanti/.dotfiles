#!/bin/bash

# Define Blender paths
BLENDER_2_79B="$HOME/Blender/blender-2.79b/blender"
BLENDER_2_92="$HOME/Blender/blender-2.92/blender"
BLENDER_3_6_11="$HOME/Blender/blender-3.6.11/blender"
BLENDER_REPO="/usr/bin/blender"

# Function to display the menu and handle selection
show_menu() {
    echo "Select the Blender version you want to launch:"
    echo "1) Blender 2.79b"
    echo "2) Blender 2.92"
    echo "3) Blender 3.6.11"
    echo "4) Blender (from repository)"
    echo "5) Cancel"
    echo -n "Please choose an option (1-5): "
}

# Display the menu and process input
while true; do
    show_menu
    read -r choice

    case $choice in
        1)
            echo "Launching Blender 2.79b..."
            "$BLENDER_2_79B"
            break
            ;;
        2)
            echo "Launching Blender 2.92..."
            "$BLENDER_2_92"
            break
            ;;
        3)
            echo "Launching Blender 3.6.11..."
            "$BLENDER_3_6_11"
            break
            ;;
        4)
            echo "Launching Blender from the repository..."
            "$BLENDER_REPO"
            break
            ;;
        5)
            echo "Cancelled."
            exit 0
            ;;
        *)
            echo "Invalid selection, please try again."
            ;;
    esac
done
