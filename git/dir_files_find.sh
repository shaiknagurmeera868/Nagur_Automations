#!/bin/bash

# Directory name
directory="path for directory"

# Output file
output_file="/Path for output file/output.txt"

# List files and save to output file
find "$directory" -type f > "$output_file"

echo "Files from $directory have been saved to $output_file"

