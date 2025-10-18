#!/bin/bash

# Check if at least one branch is provided
if [ $# -lt 1 ]; then
  echo "Usage: $0 branch_name_1 branch_name_2 branch_name_3 ..."
  exit 1
fi

# Convert arguments to an array
branches_array=("$@")

# Function to validate branch names
validate_branch_name() {
  local branch_name=$1
  if [[ ! $branch_name =~ ^[0-9]{8}$ ]]; then
    echo "Invalid branch name: $branch_name. Branch names must be 8 digits long and contain only numbers."
    exit 1
  fi
}

# Validate all branch names
for branch in "${branches_array[@]}"; do
  validate_branch_name "$branch"
done

# Path to Source Repository
Source_repo="Path for Source Repository"

# Path to Destination Repository
Destination_repo="Path for Destination Repository"

# Temporary directory to store common files
DFormat=$(date +%d%m%Y)
folder=${DFormat}
Common_files="Path for common save common files path/${folder}"
cd $Common_files
mkdir $folder

# Checkout to Destination branch of Destination Repository
cd "$Destination_repo"
git checkout Destination_Branch

# Loop through branches in Source Repository to find common files
for branch in "${branches_array[@]}"; do
  echo "Comparing branch: $branch"

  # Checkout branch from Source Repository
  cd "$Source_repo"
  git checkout "$branch"

  # Compare files in branch with Destination branch of Destination Repository
  for file in $(git ls-tree -r --name-only "$branch"); do
    if [ -f "$Destination_repo/$file" ]; then
	# if file exists in Destination Repository Destination branch, copy to Common files directory
      cd "$Source_repo"
      git checkout Source_branch
      cp --parents "$file" "$Common_files/$folder"
    fi
  done
done

# Commit "Required Commit message" changes for each branch
for branch in "${branches_array[@]}"; do
  echo "Destination_Branch out branch: $branch"

  # Checkout branch from Source Repository
  cd "$Source_repo"
  git checkout "$branch"

  # Copy files from the checked out branch in Source Repository to Destination Repository
  cd "$Source_repo"
  cp -R workspace "$Destination_repo/"

  # Switch to Destination Repository
  cd "$Destination_repo"
  git checkout Destination_Branch
  git add -A
  commit_message="Required Commit message $branch"
  git commit -m "$commit_message"
done

# Apply common files from common files directory
cd $Common_files/$folder/
cp -R  workspace "$Destination_repo/"

# Commit the changes with the provided commit message in Destination repository
cd "$Destination_repo"
git checkout Destination_Branch
git add -A
git commit -m "Required Commit message"

# Push changes to Destination branch of Destination Repository
git push origin Destination_Branch

echo "Check-in process completed."
