#!/bin/bash

## source(s)
# shellcheck disable=SC1091
source "$HOME/bin/lib/git-clone"

## variable(s)
rofi_repo="https://github.com/adi1090x/rofi"
rofi_dir="$HOME/.config/rofi.git"
rofi_launcher="$HOME/.config/rofi/launchers/type-3/launcher.sh"
rofi_power="$HOME/.config/rofi/powermenu/type-1/powermenu.sh"
launcher_theme='style-10'
power_theme='style-3'

main () {
    # clone repo
    git_clone $rofi_repo "$rofi_dir"
    
    # change directory and run setup.sh script
    cd "$rofi_dir" &> /dev/null || exit
    bash ./setup.sh

    # change directory 
    cd - &> /dev/null || exit

    # set rofi launcher themes
    sed -i "s|^theme=.*|theme='${launcher_theme}'|" "$rofi_launcher"
    sed -i "s|^theme=.*|theme='${power_theme}'|" "$rofi_power"

}

## init main
main