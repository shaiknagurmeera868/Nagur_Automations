#!/bin/bash

# list of branches from Source Repository to check out
branches=("name")

# Path to Source Repository
Source_repo="Path for Source Repository"

# Path to Destination Repository
Destination_repo="Path for Destination Repository"

# Checkout to Destination branch of Destination Repository
cd "$Destination_repo" || exit
git checkout Destination_Branch
git pull origin Destination_Branch

# Loop through branches in Source Repository
for branch in "${branches[@]}"; do
  echo "Checking out branch: $branch"

  # Checkout branch from Source Repository
  cd "$Source_repo" || exit
  git checkout "$branch"

  # Copy files from the checked out branch in Source Repository to Destination Repository
  cp -R "$Source_repo/workspace/" "$Destination_repo/"

  # Switch to Destination Repository
  cd "$Destination_repo" || exit
  git add -A
  commit_message="Required Commit message $branch"
  git commit -m "$commit_message"
done

# Push changes to checkin branch of Destination Repository
git push origin Destination_Branch

echo "Check-in process completed."
