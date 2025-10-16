#!/bin/bash

# Specify the branch name and output file path directly in the script
output_file="path for output file"
DFOrmat=$(date +%d%m%Y)
outfile=${DFOrmat}

# Path to Repo A
repoA_path="Path for repository" # Specify your Repo A path here

# Checkout to the specified branch
cd "$repoA_path" || exit
git checkout "Branch_name"

# Get the logs with commit messages, file paths, and dates and save to the specified output file
git log --name-only --pretty=format:"Commit: %h%nAuthor: %an%nDate: %ad%nMessage: %s%nFiles Changed:%n" > "$output_file/${outfile}"

# Add a separator between commits in the log
sed -i '/Files Changed:/a \--------------------------------------------\n' "$output_file/${outfile}"

echo "Logs saved to $output_file/${outfile}"
