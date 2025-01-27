#!/usr/bin/env bash

# Variables
theme="themes/one_dark.toml"
url="https://raw.githubusercontent.com/alacritty/alacritty-theme/refs/heads/master"
remoteTheme="${url}/${theme}"
script="${url}/print_colors.sh"
dir="${HOME}/.config/alacritty"

# Make $dir recursively
mkdir -p "$dir"

# Change directory $dir
cd "$dir"

# cURL download alacritty theme and the print_colors.sh script
curl -L $theme -o "$dir/$theme"
curl -L $script -O