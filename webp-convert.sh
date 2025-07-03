#!/bin/bash

# Source: https://anchor.host/converting-wordpress-uploads-to-webp/

# Usage:
# Download libwebp from: https://developers.google.com/speed/webp/download
# And make the cwebp library available globally

# curl -O https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.5.0-linux-x86-64.tar.gz
# tar -xvzf libwebp-1.5.0-linux-x86-64.tar.gz
# mv libwebp-1.5.0-linux-x86-64/bin/cwebp /usr/local/bin/cwebp

# Create a shell script with this content, name it webp-convert.sh, make it executable
# Change the "cd" dir and run this file.

cd /var/www/domain.com

before_size="$( du -sh wp-content/uploads/| awk '{print $1}' )"
echo "Current uploads size: $before_size"
files=$(find wp-content/uploads/ -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))
count=$(echo "$files" | wc -l)

if [[ $files == "" ]]; then
   echo "No images found."
   return
fi
echo "Total number of photos over 1MB: $count"

echo "$files" | while IFS= read -r file; do
    format=$( identify -format "%m" "$file" )
    if [ "$format" == "WEBP" ]; then
        continue;
    fi
    before_size=$( du -sh --apparent-size "$file" | awk '{print $1}' )
    ~/private/libwebp-1.4.0-linux-x86-64/bin/cwebp -q 80 "$file" -o "$file.temp.webp" > /dev/null 2>&1
    # Check if the conversion succeeded and the temporary file is non-zero in size
    if [ -s "$file.temp.webp" ]; then
        # Move the temp file to the original file, overwriting it
        mv "$file.temp.webp" "$file"
    else
        # If conversion failed, remove the empty temp file
        rm -f "$file.temp.webp"
        echo "Conversion failed for $file"
        continue
    fi
    after_size=$( du -sh --apparent-size "$file" | awk '{print $1}' )
    echo "Converting from $format to WEBP ($before_size -> $after_size): $file"
done

after_size="$( du -sh wp-content/uploads/ | awk '{print $1}' )"
echo "Uploads reduced from $before_size to $after_size through bulk WEBP conversion"
