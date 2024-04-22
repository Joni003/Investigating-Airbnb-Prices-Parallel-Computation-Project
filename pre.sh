#!/bin/bash

# Get the webpage
wget https://insideairbnb.com/get-the-data
mv get-the-data input.html

# Remove any preexisting data directory
#rm -rf data/

# Create a data directory
mkdir -p listings

# Extract hyperlinks associated with listings.csv.gz, calendar.csv.gz, reviews.csv.gz
grep -Eo 'href="([^"]*\/(listings)\.csv\.gz)"' input.html | \
awk -F '"' '{print $2}' > file.txt
