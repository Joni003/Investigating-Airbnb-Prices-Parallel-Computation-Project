#!/bin/bash

# Get the webpage
wget https://insideairbnb.com/get-the-data
mv get-the-data input.html

# Remove any preexisting data directory
rm -rf data/

# Create a data directory
mkdir -p data

# Extract hyperlinks associated with listings.csv.gz, calendar.csv.gz, reviews.csv.gz
grep -Eo 'href="([^"]*\/(listings|calendar|reviews)\.csv\.gz)"' input.html | \
awk -F '/' '{print $4,$5,$6}' | \
awk -F '"' '{print $1 " " $2}' | \
sort -u > data/locations.txt

# Read each line in locations.txt to create directories
while IFS= read -r location; do
    # Extract country, region, and city names from the location
    country=$(echo "$location" | awk '{print $1}')
    region=$(echo "$location" | awk '{print $2}')
    city=$(echo "$location" | awk '{print $3}')

    # Create directory if it doesn't exist
    mkdir -p "data/$country/$region/$city"
done < data/locations.txt

# Extract hyperlinks associated with listings.csv.gz, calendar.csv.gz, reviews.csv.gz
grep -Eo 'href="([^"]*\/(listings|calendar|reviews)\.csv\.gz)"' input.html | \
awk -F '"' '{print $2}' > data/file.txt

# Read each line in file.txt to download files
while IFS= read -r line; do
    # Extract country, region, and city names from the URL
    country=$(echo "$line" | awk -F '/' '{print $4}')
    region=$(echo "$line" | awk -F '/' '{print $5}')
    city=$(echo "$line" | awk -F '/' '{print $6}')

    # Download the file using wget
    wget "$line" -P "data/$country/$region/$city"
done < data/file.txt
