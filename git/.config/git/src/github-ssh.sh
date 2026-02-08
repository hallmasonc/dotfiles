#!/usr/bin/env -S bash -e

## source(s)
# shellcheck disable=SC1091
source "$HOME/bin/lib/bash-prints"

## variable(s)
SSH_DIR="$HOME/.ssh"
PUB_KEY="$SSH_DIR/*.pub"
PRIV_KEY=""
PKG_LIST=""

## function(s)
set_pkglist () {
    pkg_mgrs=("apt" "brew" "dnf" "yum" "pkg" "pacman")
    for mgr in "${pkg_mgrs[@]}"; do
        if command -v "$mgr" &> /dev/null; then
            case $mgr in
                pacman )
                    dependencies=("ssh" "openssl" "github-cli")
                    # assign calling function's variable
                    if [[ -n "$1" ]]; then
                        eval "$1='${dependencies[*]}'"
                        return 0
                    fi
                    ;;
                apt|brew|dnf|yum|pkg )
                    dependencies=("ssh" "openssl" "gh")
                    # assign calling function's variable
                    if [[ -n "$1" ]]; then
                        eval "$1='${dependencies[*]}'"
                        return 0
                    fi
                    ;;
            esac
        fi
    done

    # error if no package manager found
    return 1
}

select_key () {
    local l_privkey=""
    info_print "Private keys are expect to be named the same as public key, w/o the .pub extension."
    info_print "The following are public keys stored in $SSH_DIR:"
    # shellcheck disable=SC2086
    mapfile -t ARR < <(ls --almost-all $PUB_KEY)

    PS3="Please enter the number of the public key you want to use (e.g. 1): "
    select ENTRY in "${ARR[@]}"; do
        if [[ -n "$ENTRY" ]]; then
            l_privkey=${ENTRY%% *}
            # assign calling function's variable
            if [[ -n "$1" ]]; then
                eval "$1='$l_privkey'"
                return 0
            fi
            break
        else
            error_print "Invalid selection. Please choose a valid entry. "
            return 1
        fi
    done
}

create_key () {
    local l_privkey=""
    info_print "Creating new key pair... "

    # check for prefered ciphers
    if openssl list -public-key-algorithms | grep -q "ED25519"; then
        # user input
        input_print "Enter file in which to save the key (Default: $SSH_DIR/id_ed25519): "
        read -r l_privkey
        
        # set l_privkey if no input
        if [[ -z "$l_privkey" ]]; then
            l_privkey="id_ed25519"
        fi

        ssh-keygen -t ed25519 -f "$SSH_DIR/$l_privkey"
    else
        # user input
        input_print "Enter file in which to save the key (Default: $SSH_DIR/id_rsa): "
        read -r l_privkey
        
        # set l_privkey if no input
        if [[ -z "$l_privkey" ]]; then
            l_privkey="id_rsa"
        fi

        ssh-keygen -t rsa -b 4096 -f "$SSH_DIR/$l_privkey"
    fi

    # assign calling function's variable
    if [[ -n "$1" ]]; then
        eval "$1='$l_privkey'"
        return 0
    fi
}

main () {
    # generate package list and check package availability
    if set_pkglist "PKG_LIST"; then
        for pkg in $PKG_LIST; do
            check-pkg "$pkg"
        done
    else
        error_print "No suitable package manager found."
        exit 1
    fi

    # check for existing SSH keys
    if ls "$SSH_DIR"/*.pub &> /dev/null; then
        # user input
        input_print "A SSH key pair(s) already exist. Do you want to use one already generated? (y/N): "
        read -r user_choice
        case $user_choice in
            y|Y ) select_key "PRIV_KEY";;    
            * ) create_key "PRIV_KEY";;
        esac
    else
        create_key "PRIV_KEY"
    fi

    # authenticate w/ github-cli
    info_print "Running github-cli to authenticate to GitHub."
    gh auth login

    # configure ssh-agent
    eval "$(ssh-agent -s)"
    ssh-add "$PRIV_KEY"
}

## init main
main