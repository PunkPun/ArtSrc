#!/bin/bash

mkdir -p png-output
find . -name "*.svg" | while read svg; do
    echo ""
    echo "Converting $svg to PNG"

    base_name=$(basename "$svg" .svg)
    rel_path=$(dirname "$svg")
    output_dir="png-output/$rel_path"
    mkdir -p "$output_dir"

    # inkscape "$svg" --actions="export-background-opacity:0;
    # export-background:none
    # export-type:png;
    # export-filename:$output_dir/${base_name}.png;
    # export-dpi:96;
    # export-do;
    # export-filename:$output_dir/${base_name}-2x.png;
    # export-dpi:192;
    # export-do;
    # export-filename:$output_dir/${base_name}-3x.png;
    # export-dpi:288;
    # export-do;"

    Generate 1x PNG
    inkscape "$svg" --export-type=png --export-filename="$output_dir/$base_name.png" --export-background-opacity=0 --export-dpi=96 --export-background=none

    # Generate 2x PNG
    inkscape "$svg" --export-type=png --export-filename="$output_dir/${base_name}-2x.png" --export-background-opacity=0 --export-dpi=192 --export-background=none

    # Generate 3x PNG with padding
    inkscape "$svg" --export-type=png --export-filename="/tmp/${base_name}-3x.png" --export-background-opacity=0 --export-dpi=288 --export-background=none

    # Add padding to 3x image (ensure padding is transparent)
    width=$(identify -format "%w" "/tmp/${base_name}-3x.png")
    height=$(identify -format "%h" "/tmp/${base_name}-3x.png")
    convert "/tmp/${base_name}-3x.png" -background none -gravity northwest \
        -extent "$((width * 4 / 3))x$((height * 4 / 3))" "$output_dir/${base_name}-3x.png"
done
