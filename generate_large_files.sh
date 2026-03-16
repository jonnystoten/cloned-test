#!/bin/bash
# Generate large random binary files for testing git with large repos

NUM_FILES=23
MIN_MB=20
MAX_MB=90
OUTPUT_DIR="large_files"

mkdir -p "$OUTPUT_DIR"

for i in $(seq 1 $NUM_FILES); do
    size=$(( RANDOM % (MAX_MB - MIN_MB + 1) + MIN_MB ))
    filename="$OUTPUT_DIR/blob_${i}.bin"
    echo "Generating $filename (${size}MB) — ~80% repeating, ~20% random..."

    # Generate a 1MB random pattern block, then tile it for most of the file
    # and mix in some random chunks to keep it partially unique
    pattern_file=$(mktemp)
    dd if=/dev/urandom of="$pattern_file" bs=1M count=1 2>/dev/null

    repeat_mb=$(( size * 80 / 100 ))
    random_mb=$(( size - repeat_mb ))

    # Write repeating pattern blocks
    for _ in $(seq 1 $repeat_mb); do
        cat "$pattern_file"
    done > "$filename"

    # Append random data
    dd if=/dev/urandom bs=1M count="$random_mb" 2>/dev/null >> "$filename"

    rm -f "$pattern_file"
    actual=$(du -m "$filename" | cut -f1)
    echo "  wrote ${actual}MB"
done

echo "Done. Generated $NUM_FILES files in $OUTPUT_DIR/"
ls -lh "$OUTPUT_DIR/"
