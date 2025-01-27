#!/usr/bin/env bash

# Variables
dir="${HOME}/.config/alacritty"
theme="themes/one_dark.toml"
script="print_colors.sh"
remote="https://raw.githubusercontent.com/alacritty/alacritty-theme/refs/heads/master"
remoteTheme="${remote}/${theme}"
remoteScript="${remote}/${script}"

# Make $dir recursively
mkdir -p "$dir/themes"

# Change directory $dir
cd "$dir"

# cURL download alacritty theme and the print_colors.sh script
curl -L $remoteTheme -o "$dir/$theme"
curl -L $remoteScript -o "$dir/$script"