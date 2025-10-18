#!/bin/bash

Source_repo="path for source repository"
Destination_repo="path for destination repository"
workspace="some_workspace"

cd "$Source_repo"
git checkout "Source_branch"

cd "$Destination_repo"
git checkout "destination_Branch"

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <directory_with_files>"
  exit 1
fi

DIR_WITH_FILES="$1"

BRANCH_NAME=$(basename "$DIR_WITH_FILES" | cut -c1-8)

if [[ ! $BRANCH_NAME =~ ^[0-9]{8}$ ]]; then
  echo "Invalid branch name: ${BRANCH_NAME}. Branch names must be 8-digit numbers."
  exit 1
fi

NEW_BRANCH="${BRANCH_NAME}_destination_Branch"

cd "$Source_repo"
git branch "$NEW_BRANCH"

cp -R "path for source directory" "$Source_repo"

cd "$Source_repo"
git checkout "$NEW_BRANCH"
git add -A
git commit -m "$NEW_BRANCH"
git push origin "$NEW_BRANCH"

cd "$Source_repo"
git checkout "$NEW_BRANCH"
cp -R "path for source branch directory" "$Destination_repo"

cd "$Destination_repo"
git checkout "destination_Branch"
git add -A
git commit -m "$NEW_BRANCH"
git push origin "destination_Branch"
