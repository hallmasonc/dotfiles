#!/usr/bin/env bash

## variable(s)
dir="$HOME/.config/alacritty"
remote="https://raw.githubusercontent.com/alacritty/alacritty-theme/refs/heads/master"
script="print_colors.sh"
theme="themes/one_dark.toml"

## function(s)
main () {
    # make directory
    mkdir -p "$dir/themes" &> /dev/null

    # change directory
    cd "$dir" &> /dev/null || exit

    # cURL download alacritty theme and the print_colors.sh script
    curl -L "$remote/$theme" -o "$dir/$theme" &> /dev/null
    curl -L "$remote/$script" -o "$dir/$script" &> /dev/null

    # return to previous directory
    cd - &> /dev/null || exit

    # make script executable
    chmod +x "$dir/$script"
}

## main
main