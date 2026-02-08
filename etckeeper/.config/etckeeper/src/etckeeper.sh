#!/usr/bin/env -S bash -e

## source(s)
# shellcheck disable=SC1091
source "$HOME/bin/lib/bash-prints"

## variable(s)
REMOTE="https://github.com/hallmasonc"
REPO="etc-$(hostname | tr '[:upper:]' '[:lower:]')"

## function(s)
main () {
    # check auth status with github-cli
    info_print "Checking authentication status of github-cli... "
    if ! gh auth status &> /dev/null; then
        error_print "Not connected using github-cli. Running configuration script... "
        bash "$HOME/.config/git/src/github-ssh.sh"
    else
        info_print "Authenticated using github-cli."
    fi
    
    # check if /etc is a local repository
    if [ ! -d /etc/.git ]; then
        info_print "Initializing git repository in /etc... "
        sudo etckeeper init
    else
        info_print "Found git repository in /etc."
    fi

    # check if branch is 'main'
    if [[ "$(sudo etckeeper vcs branch --show-current)" == "master" ]]; then
        error_print "Current branch is master."
        info_print "Moving to main branch and adding initial commit... "
        sudo etckeeper vcs branch --move master main
        sudo -E etckeeper commit "init"
    else
        info_print "Checking out main branch... "
        sudo etckeeper vcs checkout -b main
        sudo -E etckeeper commit "init"
    fi

    # check if local repo has remote 'origin' set
    if ! sudo etckeeper vcs remote show origin &> /dev/null; then
        info_print "Adding remote origin $REMOTE/$REPO"
        sudo etckeeper vcs remote add origin "$REMOTE/$REPO"
    else
        info_print "Remote origin is already set."
    fi

    # remove staged changes and pull from remote
    if ! sudo -E etckeeper vcs rm --cached -- . &> /dev/null; then
        error_print "Could not unstage current changes."
        info_print "Stashing changes... "
        sudo etckeeper vcs stash push
        sudo -E etckeeper vcs pull --rebase origin main
        sudo etckeeper vcs stash pop
    else
        sudo -E etckeeper vcs pull --rebase origin main
    fi
        info_print "Done! Please use etckeeper to confirm local and remote repo status."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi