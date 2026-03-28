#!/bin/bash

## variable(s)
rofi_repo="https://github.com/adi1090x/rofi"
rofi_dir="$HOME/.config/rofi.git"
rofi_launcher="$HOME/.config/rofi/launchers/type-3/launcher.sh"
rofi_power="$HOME/.config/rofi/powermenu/type-1/powermenu.sh"
launcher_theme='style-10'
power_theme='style-3'

## function(s)
git_clone () {
    # check if destination path exists
    if [[ -d $2 ]]; then
        info_print "The destination path already exists. Fetching from the remote repository. "
        
        # change directory and git fetch and pull
        cd "$2" &> /dev/null || exit
        if git fetch &> /dev/null; then
            if git pull &> /dev/null; then
                info_print "Successfully pulled down the latest files from remote repository! "
            else
                error_print "Couldn't pull latest files from remote repository. "
            fi
        else
            error_print "Unable to fetch from the remote repository. "
        fi

        # change directory and continue
        cd - &> /dev/null || exit
    else
        info_print "Attempting to clone into: $2"

        # clone from remote repository to destination path
        if git clone "$1" "$2" &> /dev/null; then
            info_print "Clone successful!"
        else
            error_print "Clone failed for $1"
            exit 1
        fi
    fi
}

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