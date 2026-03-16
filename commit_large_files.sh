#!/bin/bash
# Commit each large file individually, one commit per file

OUTPUT_DIR="large_files"

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Error: $OUTPUT_DIR/ not found. Run generate_large_files.sh first."
    exit 1
fi

for file in "$OUTPUT_DIR"/*.bin; do
    [ -f "$file" ] || continue
    filename=$(basename "$file")
    git add "$file"
    git commit -m "Add $filename"
    echo "Committed $filename"
done

echo "Done. All files committed."
git log --oneline
