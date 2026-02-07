#!/bin/bash

## source(s)
source ./lib/bash-prints

## variable(s)
rofi_repo="https://github.com/adi1090x/rofi"
rofi_dir="$HOME/.config/rofi.git"
rofi_launcher="$HOME/.config/rofi/launchers/type-3/launcher.sh"
rofi_power="$HOME/.config/rofi/powermenu/type-1/powermenu.sh"
launcher_theme='style-10'
power_theme='style-3'

## function(s)
git_clone () {
    info_print "Attempting to clone into: $2"

    if git clone "$1" "$2"; then
        info_print "Clone successful!"
    else
        error_print "Clone failed for $1"
        exit 1
    fi
}

main () {
    # clone repo
    git_clone $rofi_repo "$rofi_dir"
    
    # setup rofi themes
    cd "$rofi_dir" || exit
    bash ./setup.sh
    cd - || exit

    # modify rofi themes
    sed -i "s|^theme=.*|theme='${launcher_theme}'|" "$rofi_launcher"
    sed -i "s|^theme=.*|theme='${power_theme}'|" "$rofi_power"

}

## init main
main