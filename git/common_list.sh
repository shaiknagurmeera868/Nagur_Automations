#!/bin/bash

Source_repo="Source repository path"
Destination_repo="Destination repository path"
DFormat=$(date +%d%m%Y)
folder=${DFormat}

validate_branch() {
  if [[ ! $1 =~ ^[0-9]{8}$ ]]; then
    echo "Invalid branch name: $1. Branch names must be 8-digit numbers."
    exit 1
  fi
}

get_file_list() {
  local repo_path=$1
  cd "$repo_path"
  cd workspace
  git ls-tree -r --name-only HEAD | awk -F/ '{print $NF}'
}

if [ "$#" -lt 1 ]; then
  echo "No branch names provided."
  exit 1
fi

if [ $? -ne 0 ]; then
  echo "Failed to checkout master branch in B repository."
  exit 1
fi

cd "$Destination_repo"
git checkout master
cd workspace
master_files=$(get_file_list "$Destination_repo")


for branch in "$@"
do
  validate_branch "$branch"

  branch_dir="/output_path/${folder}/${branch}"
  mkdir -p "$branch_dir"

  if [ $? -ne 0 ]; then
    echo "Failed to checkout branch: $branch in A repository."
    exit 1
  fi

  cd "$Source_repo"
  git checkout "$branch"
  cd workspace
  branch_files=$(get_file_list "$Source_repo")
  echo "$branch_files" > "$branch_dir/${branch}_all.txt"
  echo "$branch_files" | sed 's/\.[^.]*$//' | grep -Pv '\d' > "$branch_dir/${branch}_common.txt"
  echo "$branch_files" | grep -F -f <(echo "$master_files") > "$branch_dir/${branch}_old.txt"
  echo "$branch_files" | grep -v -F -f <(echo "$master_files") > "$branch_dir/${branch}_new.txt"
done
