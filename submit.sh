#!/bin/bash

tar -xzf R413.tar.gz

export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R

link=$1

#destination_dir="./listings"
#mkdir -p "$destination_dir"

country=$(echo "$link" | awk -F'/' '{print $4}')
city=$(echo "$link" | awk -F'/' '{print $6}')

filename="${country}_${city}.csv"
gz_file_path="${country}_${city}.csv.gz"
#csv_file_path="$destination_dir/$filename"

wget -c -O "$gz_file_path" "$link"

gzip -d -c "$gz_file_path" > "$filename"

rm "$gz_file_path"

Rscript script.R $filename
