#!/usr/bin/env bash

## source(s)
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
# shellcheck disable=SC1091
source "$SCRIPT_DIR/bin/bin/lib/bash-"prints

## variable(s)
# shells
bashrc="$HOME/.bashrc"
bashprof="$HOME/.bash_profile"
zshrc="$HOME/.zshrc"

# folders - local user
useronly=(
    alacritty
    bash
    bin
    code
    colors
    fastfetch
    git
    kanshi
    rofi
    sway
    swaylock
    systemd
    waybar
    xdg
    zsh
)

root=()

## function(s)
file_exists () {
    if [[ -e $1 ]]; then
        input_print "$1 has been found, replace it? [y/n]: "
        read -r user_input
        if [[ "${user_input,,}" =~ ^(yes|y)$ ]]; then
            rm "$1"
        fi
    fi
}

main () {
    # check 
    case $(whoami) in
        root)
            # install configs in a root environment
            for app in "${root[@]}"; do
                :
            done ;;
        *)
            # change directory
            cd "$HOME/.dotfiles/" &>/dev/null || exit

            # check if .bashrc exists and remove
            file_exists "$bashrc"

            # check if .bash_profile exists and remove
            file_exists "$bashprof"

            # check if .zshrc exists and remove
            file_exists "$zshrc"
            
            # install only user space folders
            info_print "Stowing apps for user: $(whoami)"
            for app in "${useronly[@]}"; do
                stow -v -R --no-folding -t "${HOME}" "$app"
            done ;;
    esac

    info_print "Finished moving configurations!"
}

## init main
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
