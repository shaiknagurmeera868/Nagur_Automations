#!/bin/bash

repo_path="path for source repository"
source_branch="source branch name"
target_branch="target branch name"

if [ ! -d "$repo_path" ]; then
    echo "Error: Repository path '$repo_path' does not exist."
    exit 1
fi

cd "$repo_path" || exit

git fetch origin

git checkout $target_branch
if [ $? -ne 0 ]; then
    echo "Error: Branch '$target_branch' does not exist."
    exit 1
fi

for commit_id in "$@"
do
    echo "Cherry-picking commit: $commit_id from $source_branch to $target_branch."
    git cherry-pick $commit_id

    if [ $? -ne 0 ]; then
        echo "Error cherry-picking commit: $commit_id, please resolve conflicts manually."
        exit 1
    fi
done

echo "All commits successfully cherry-picked to $target_branch."
