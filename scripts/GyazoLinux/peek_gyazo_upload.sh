#!/bin/bash
# Description: Takes a screen recording with Peek, uploads it to Gyazo, and opens the link in the browser.

# Peek saves recordings in the user's Videos/Peek directory by default
peek_dir="$HOME/Videos/Peek"
if [ ! -d "$peek_dir" ]; then
    echo "Peek directory does not exist. Please make sure Peek is installed and configured properly."
    exit 1
fi

# Start Peek recording (this opens the Peek window for recording)
peek

# Wait for the user to complete the recording
echo "Please complete the recording in Peek and press Enter to continue."
read -r

# Find the latest GIF file in the Peek directory
file=$(ls -t "$peek_dir"/*.gif 2>/dev/null | head -n 1)

if [ ! -f "$file" ]; then
    echo "No GIF file found. Recording may have failed or was cancelled."
    exit 1
fi

# URL for Gyazo upload
url=https://upload.gyazo.com/upload.cgi

# Check if the file is too large (Gyazo limit is 10 MB)
bytes=$(wc -c < "$file")
if [ $bytes -gt 10485760 ]; then
    echo "File is too large"
    exit 1
fi

echo "Uploading $file ($bytes bytes)..."

# Upload image
response=$(curl -s -F "imagedata=@$file" $url)

# Open the response link in the default browser
if [ -n "$response" ]; then
    xdg-open "$response"
else
    echo "Failed to upload the image."
fi
