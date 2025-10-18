#!/bin/bash

#Paths

SOURCE_DIRECTORY="Source directory path"
DEST_DIRECTORY="Destination directory path"
FILE_PATHS_LIST="Paths list files for output path/output.txt"

# If file paths list unda check chayadam
if [ ! -f $FILE_PATHS_LIST ]; then
  echo "File paths list not found: $FILE_PATHS_LIST"
  exit 1
fi

# File paths list manual copy chayadam
mkdir -p $DEST_DIRECTORY
while IFS= read -r file; do
  if [ -f "$SOURCE_DIRECTORY/$file" ]; then
	  mkdir -p "$DEST_DIRECTORY/$(dirname "$file")"
	  cp "$SOURCE_DIRECTORY/$file" "$DEST_DIRECTORY/$file"
  else
    echo "File not found in source directory: $SOURCE_DIRECTORY/$file"
  fi
done < $FILE_PATHS_LIST

echo "Specified files from $SOURCE_DIRECTORY copied to $DEST_DIRECTORY"

