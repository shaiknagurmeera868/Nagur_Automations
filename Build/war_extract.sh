#!/bin/bash

Project="all project path"
Source_of_War_File="/Source/file/path/NBC.war"
Depended_Paths="Path"
War_file_Extract="path"
War_file_Extract_2="Path"
Destination_War="path/NBC.war"

cd "Project"
mvn clean install

cd "$War_file_Extract"
jar xvf "$Source_of_War_File"

cd "$Depended_Paths"
cp -r "Depended_folder-1" $War_file_Extract
cp -r "Depended_folder-2" $War_file_Extract_2

cd "$War_file_Extract"
jar cvf "$Destination_War" *

