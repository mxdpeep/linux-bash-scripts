#!/bin/bash

# Function to count zero-length files in a .dslibrary archive
count_zero_length_files_in_archive() {
    local dslibrary_file="$1"
    local zero_count=0

    # Check if the file is actually a zip file and list its contents
    # Filter for lines that start with 0 (padded with spaces) in the 'Length' column
    # The output of unzip -l typically looks like:
    # Length   Date   Time   Name
    # -------- -------- --------   ----
    #        0 07-15-25 08:00   empty_file.txt
    #      123 07-15-25 08:01   data.txt
    # --------                   -------
    # So we're looking for lines starting with whitespace followed by 0,
    # and then ignoring the summary lines.

    # Use awk to filter and count:
    # NR > 3: Start processing after the header lines.
    # $1 ~ /^[ ]*0$/: Check if the first field (Length) is exactly 0.
    # $NF !~ /\/$/: Ensure the last field (Name) does not end with '/' (i.e., is not a directory).
    zero_count=$(unzip -l "$dslibrary_file" 2>/dev/null | awk '
        NR > 3 && $1 ~ /^[ ]*0$/ && $NF !~ /\/$/ {
            print "  - Found zero-length file: " $NF;
            count++;
        }
        END { print "TOTAL_COUNT:" count }
    ' | grep -oP 'TOTAL_COUNT:\K[0-9]+$')

    echo "$zero_count"
}

# Main script logic
main() {
    # Trap Ctrl+C (SIGINT) to perform a graceful exit
    trap 'echo -e "\n\e[31mScript terminated by user (Ctrl+C).\e[0m"; exit 1' SIGINT

    local root_dir=$(pwd)
    local total_zero_length_files=0
    declare -A zero_length_counts # Associative array to store counts per file

    echo -en "Scan: $(realpath "$root_dir")\n\n"

    # Find all .dslibrary files recursively
    # -type f: ensures it's a file
    # -name "*.dslibrary": matches the file extension
    while IFS= read -r filepath; do
        echo -en "Checking: $filepath"

        # Verify if it's a ZIP file (a basic check, 'unzip' will fail if not)
        if ! unzip -t "$filepath" &>/dev/null; then
            echo -e "  \e[31mWarning: '$filepath' is not a valid ZIP file and cannot be processed.\e[0m"
            continue
        fi

        local current_zero_count=$(count_zero_length_files_in_archive "$filepath")

        if [[ "$current_zero_count" -gt 0 ]]; then
            zero_length_counts["$filepath"]="$current_zero_count"
            total_zero_length_files=$((total_zero_length_files + current_zero_count))
            echo -en " \e[31m$current_zero_count\e[0m"
        fi
        echo ""

    done < <(find "$root_dir" -type f -name "*.dslibrary")

    echo "--- Scan Complete ---"
    echo "Total empty files found across all .dslibrary files: $total_zero_length_files"

    if [[ ${#zero_length_counts[@]} -gt 0 ]]; then
        echo ""
        echo "Summary of empty files:"
        for dslib_path in "${!zero_length_counts[@]}"; do
            echo -en "- '$dslib_path' \e[31m${zero_length_counts[$dslib_path]}\e[0m\n"
        done
    else
        echo ""
        echo "No .dslibrary files with zero-length internal files were found."
    fi
}

# Execute the main function
main
