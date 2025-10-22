#!/bin/bash

# Required Paths

metadata="/Path"
channel="/path"
Destination="/path"

#New folder creation

folder=$(date +%d%m%Y)_$(date +%R)
cd "$Destination"
mkdir $folder

# Create Zip files

cd $metadata
zip -r MetaData.zip MetaData
mv MetaData.zip $source/$folder

cd $channel
zip -r Channel.zip Channel
mv Channel.zip $source/$folder

