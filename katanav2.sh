#!/bin/bash

# Read the last scanned line number
if [ -f last_line.txt ]; then
    last_line=$(cat last_line.txt)
else
    last_line=0
fi

# Loop over each website and scan it
i=0
while read website; do
    i=$((i+1))
    if [ $i -le $last_line ]; then
        continue
    fi
    echo "Scanning website: $website"
    katana -jc -aff -d 5 -f qurl "$website" | grep "=" >> "result-$i.txt"
    echo $i > last_line.txt
done < websites.txt

echo "Scan completed."
