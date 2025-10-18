Source_Repo_path="source Repository path"
File_path="Components-paths to save the txt file inside of directory"
create="Component to save the inside of directory"
DFormat=$(date +%d%m%Y)
outfile=${DFormat}
folder=${DFormat}
folder1=${DFormat}
cd $File_path
mkdir $folder
cd $Source_Repo_path
git checkout "source branch"
file_paths=(
"past to the file names to one by one"

)

# Loop to take files name to open by one
for files in "${file_paths[@]}"; do
  find "$Source_Repo_path" -type f -name "$files" >> $File_path/$folder/${outfile}
done

set -e

while IFS= read -r files_copy; do
	file_directory=($folder1 "${files_copy#$Source_Repo_path}")
  mkdir -p "$create/$folder1"
  cp "$files_copy" "$create/$file_directory"
done < $File_path/$folder/${outfile}

echo "Done"

