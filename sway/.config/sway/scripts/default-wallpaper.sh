#!/bin/bash

## variable(s)
img="https://raw.githubusercontent.com/Narmis-E/onedark-wallpapers/refs/heads/main/misc/od_vaporwave.png"

## function(s)
download_wallpaper () {
    if [ ! -d $HOME/Pictures/Wallpapers ]; then
        mkdir -p $HOME/Pictures/Wallpapers
    fi

    if ! curl -o $HOME/Pictures/Wallpapers/default.png $img; then
        error_print "Failed to download default wallpaper"
        exit 1
    fi
}

set_wallpaper () {
    if [ -e $HOME/.config/sway/config ]; then
        sed -i 's/#output \* bg .* fill/output \* bg $HOME\/Pictures\/Wallpapers\/default.png fill/' .config/sway/config
    fi
}

## main
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    download_wallpaper
    set_wallpaper
fi
