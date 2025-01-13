#!/usr/bin/env bash

# Variables
url="https://raw.githubusercontent.com/alacritty/alacritty-theme/refs/heads/master"
theme="${url}/themes/gruvbox_material_hard_dark.toml"
script="${url}/print_colors.sh"
dir="${HOME}/.config/alacritty"

# Make $dir recursively
mkdir -p "$dir"

# Change directory $dir
cd "$dir"

# cURL download alacritty theme and the print_colors.sh script
curl -L $theme -o "$dir/themes/gruvbox_material_hard_dark.toml"
curl -L $script -O