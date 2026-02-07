#!/usr/bin/env bash

## variable(s)
old_IFS=$IFS
required_pkgs=(codium)
config_file=$HOME/.config/VSCodium/User/globalStorage/zokugun.sync-settings/setting.yml

## function(s)
backup_config () {
    if [ -f "$config_file" ]; then
        cp "$config_file" "$config_file.bak"
    fi
}

restore_config () {
    if [ -f "$config_file" ]; then
        cp "$config_file.bak" "$config_file"
    fi
}

## main
main () {
    # backup the custom config pulled from .dotfiles
    backup_config

    # install extension
    codium --install-extension zokugun.sync-settings

    # restore the custom config from .dotfiles
    restore_config
}

IFS=,

if check-pkg -r "${required_pkgs[*]}"; then
    main
fi

IFS=$old_IFS