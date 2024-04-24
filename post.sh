# Create subfolder if it doesn't exist
mkdir -p listings/unfiltered

# Move files not ending in "filtered.csv" to the subfolder
for file in listings/*; do
    if [[ -f "$file" && ! "$file" =~ filtered.csv$ ]]; then
        mv "$file" listings/unfiltered/
    fi
done
