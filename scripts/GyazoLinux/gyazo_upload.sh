#!/bin/bash
# Description: Uploads an image to gyazo and opens the link in the browser
url=https://upload.gyazo.com/upload.cgi
file=$1

#Read Image file for upload
if [ -z $file ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

bytes=$(wc -c < $file)
if [ $bytes -gt 10485760 ]; then
    echo "File is too large"
    exit 1
fi

echo "Uploading $file ($bytes bytes)..."

#Upload image
response=$(curl -s -F "imagedata=@$file" $url)
xdg-open $response
