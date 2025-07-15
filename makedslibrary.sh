#!/bin/bash
# Google Gemini 2025-07-13

# Enable nullglob: If no files match the pattern, the glob expands to nothing,
# preventing the script from trying to process a literal "*.dsbundle".
shopt -s nullglob

# Set Internal Field Separator to newline only to handle filenames with spaces correctly.
IFS=$'\n'

# Flag to check if any .dsbundle directories were found and processed.
found_bundles=false

# Loop through all directories ending with .dsbundle in the current directory.
for bundle_dir in *.dsbundle; do

  # Check if the current item is actually a directory.
  if [[ -d "$bundle_dir" ]]; then
    found_bundles=true

    # Construct the output .dslibrary filename.
    # We remove the '.dsbundle' extension and append '.dslibrary'.
    library_name="${bundle_dir%.dsbundle}.dslibrary"
    if [[ -f "$library_name" ]]; then
      echo "> '$library_name' already exists"
      continue
    fi

    echo "Archiving '$bundle_dir'..."

    # Use the 'zip' command:
    # -0 : Store files only, do not compress. This is key for "faster to load".
    # -r : Recurse into directories (necessary to archive the entire bundle_dir).
    zip -0 -q -r "$library_name" "$bundle_dir"

    # Check the exit status
    if [[ $? -eq 0 ]]; then
      echo "Successfully created '$library_name'."
    else
      echo "Error creating '$library_name'. Please check the error messages above."
    fi
  fi
done

if ! $found_bundles; then
  echo "No *.dsbundle directories found in the current directory."
fi

echo "Done."

# Restore IFS
unset IFS
