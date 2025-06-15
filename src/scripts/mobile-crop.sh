#!/bin/bash

# Usage: ./mobile-crop.sh input.jpg [output.jpg]

input="$1"
output="${2:-out.jpg}"

if [[ ! -f "$input" ]]; then
  echo "Usage: $0 input_image [output_image]"
  exit 1
fi

# Get original height using ImageMagick identify (more reliable than file)
orig_height=$(identify -format "%h" "$input")

# Your phone's width/height
phone_width=1080
phone_height=2316

# Calculate crop width (rounded)
crop_width=$(awk "BEGIN {printf \"%d\", $orig_height * $phone_width / $phone_height}")

magick "$input" -gravity center -crop "${crop_width}x${orig_height}+0+0" +repage "$output"

echo "Done: $output"
