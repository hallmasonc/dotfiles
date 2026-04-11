#!/usr/bin/env bash

## source(s)
# shellcheck disable=SC1091
source "$HOME/bin/lib/bash-prints"

## variable(s)
install_dir="$HOME/bin"
dependencies=(curl unzip coreutils)

## function(s)
check_dep () {
    # iterate through dependencies
    info_print "Checking for required packages... "
    for dep in "${dependencies[@]}"; do
        check-pkg -r "$dep"
    done
}

main () {
    # check if install directory exists; if not, mkdir
    if ! [[ -d "$install_dir" ]]; then
        mkdir "$install_dir"
    fi

    # 
    info_print "Running oh-my-posh install script... "
    if ! curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$install_dir" > /dev/null; then
        error_print "Failed to complete the oh-my-posh script."
    else
        info_print "Done! "
    fi
}

## invoke main if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if check_dep; then
        main
    fi
fi