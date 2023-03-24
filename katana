#!/bin/bash

# Read the websites from the file "websites.txt"
websites=$(cat websites.txt)

# Loop through each website and scan it using Katana
count=1
for website in $websites
do
  # Construct the output filename for this scan
  output_file="result-$count.txt"

  # Scan the website and save the output to the output file
  echo "Scanning website: $website"
  echo $website | katana -jc -aff -d 5 -f qurl | grep "=" > "$output_file"

  # Check if the output file is empty and remove it if so
  if [ ! -s "$output_file" ]
  then
    echo "Scan for website $website failed"
    rm "$output_file"
  else
    echo "Scan for website $website completed successfully"
  fi

  # Increment the count for the next output file
  ((count++))
done

echo "All scans completed." 
