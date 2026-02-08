#!/usr/bin/env -S bash -e

## source(s)
# shellcheck disable=SC1091
source "$HOME/bin/lib/bash-prints"

## variable(s)
REMOTE="https://github.com/hallmasonc"
REPO="etc-$(hostname | tr '[:upper:]' '[:lower:]')"

## function(s)
main () {
    info_print "Checking authentication status of github-cli... "
    if ! gh auth status &> /dev/null; then
        error_print "Not connected using github-cli. Running configuration script... "
        bash "$HOME/.config/git/src/github-ssh.sh"
    else
        info_print "Authenticated using github-cli."
    fi
    
    if [ ! -d /etc/.git ]; then
        info_print "Initializing git repository in /etc... "
        sudo etckeeper init
    else
        info_print "Found git repository in /etc."
    fi

    if ! sudo -E etckeeper vcs remote show origin &> /dev/null; then
        info_print "Configuring remote \"origin\" at $REMOTE/$REPO"
        sudo -E etckeeper vcs remote add origin "$REMOTE/$REPO"
        sudo -E etckeeper vcs branch --set-upstream-to=origin/main main
        sudo -E etckeeper vcs pull
    else
        info_print "Remote origin is already set."
        info_print "Done! Please use etckeeper to confirm local and remote repo status."
    fi
    
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi