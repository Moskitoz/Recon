#!/bin/bash

echo "Please select the scan mode:"
echo "1. Low"
echo "2. Medium"
echo "3. High"
read depth

case $depth in
  1) depth_val=2;;
  2) depth_val=5;;
  3) depth_val=9;;
  *) echo "Invalid option selected"; exit 1;;
esac

echo "Do you want to resume the previous scan? (y/n)"
read resume

if [[ "$resume" == "y" ]]; then
  if [[ -f "scan.log" ]]; then
    echo "Resuming previous scan..."
    last_scan=$(tail -n 1 scan.log)
    while read line; do
      if [[ "$line" == "$last_scan" ]]; then
        start_scan="y"
      fi
      if [[ "$start_scan" == "y" ]]; then
        website="$line/"
        echo "Scanning website: $line"
        cmd="echo $line | katana -jc -aff -d $depth_val -f qurl | grep \"=\" >> result-$(($i+1)).txt"
        echo "Running command: $cmd"
        eval $cmd
      fi
    done < websites.txt
  else
    echo "No previous scan found. Starting a new scan..."
    resume="n"
  fi
fi

if [[ "$resume" == "n" ]]; then
  echo "Starting a new scan ..."
  echo "" > scan.log
  i=0
  while read line; do
    website="$line/"
    i=$((i+1))
    echo "Scanning website: $line"
    cmd="echo $line | katana -jc -aff -d $depth_val -f qurl | grep \"=\" >> result-$i.txt"
    echo "Running command: $cmd"
    echo $line >> scan.log
    eval $cmd
  done < websites.txt
fi

echo "Press CTRL+C to halt the scan and resume later."
trap "echo 'Scan halted by user.'; echo $line >> scan.log; exit 1" INT
