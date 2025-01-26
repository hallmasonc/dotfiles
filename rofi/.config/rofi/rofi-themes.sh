#!/bin/bash

## Variables
rofi="https://github.com/hallmasonc/rofi"
rofiDir="$HOME/.config/rofi.git"

## Functions
# git clone function
cloneFunction () {
    if [ -d "$2" ]; then
        echo "Directory already exists; overwriting!"

        # remove target directory
        rm -rf $2
    fi

    # clone
    git clone $1 $2
}
# main function
main () {
    # clone rofi themes
    cloneFunction $rofi $rofiDir

    # change directory to newly cloned directory
    cd $rofiDir

    # run rofi setup.sh
    bash ./setup.sh
    
    # change to previous directory
    cd -
}

## Run main
main