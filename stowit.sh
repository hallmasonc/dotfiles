#!/usr/bin/env bash

# folders - local user
useronly=(
    alacritty
    bash
    bin
    code
    colors
    etckeeper
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

# change directory
cd "$HOME/.dotfiles/" || exit

stow_over () {
    if [[ "$(whoami)" != "root" ]]; then
        stow -v -R --no-folding --override="/$1/" -t "$2" "$3"
    fi
}

stowit () {
    if [[ "$(whoami)" != "root" ]]; then
        stow -v -R --no-folding -t "$1" "$2"
    fi
}

echo "###    Stowing apps for user: $(whoami)    ###"
echo ""

# install only user space folders
for app in "${useronly[@]}"; do
    case $app in
        bash )
            if ! grep -q STOW-OVERRIDE-BLOCK "$HOME/.bashrc"; then    
                stow_over ".bashrc" "${HOME}" "$app"
            else
                stowit "${HOME}" "$app"
            fi ;;
        zsh )
            if ! grep -q STOW-OVERRIDE-BLOCK "$HOME/.zshrc"; then                
                stow_over ".zshrc" "${HOME}" "$app"
            else
                stowit "${HOME}" "$app"
            fi ;;
        * )
            if [[ "$(whoami)" != "root" ]]; then
                stow -v -R --no-folding -t "${HOME}" "$app"
            fi
    esac
done

echo ""
echo "###   Finished moving configurations!   ###"
