#!/usr/bin/env bash

# folders that should, or only need to be installed for a local user
useronly=(
    alacritty
    git
    kanshi
    rofi
    sway
    zsh
)

# change directory
cd ~/.dotfiles/

# run the stow command for the passed in directory ($2) in location $1
stowit() {
    usr=$1
    app=$2
    # -v verbose
    # -R recursive
    # -t target
    stow --no-folding -v -R -t ${usr} ${app}
}

echo "###    Stowing apps for user: $(whoami)    ###"
echo ""

# install only user space folders
for app in ${useronly[@]}; do
    if [[ "$(whoami)" != "root" ]]; then
        stowit "${HOME}" $app
    fi
done

echo ""
echo "###   Finished moving configurations!   ###"
