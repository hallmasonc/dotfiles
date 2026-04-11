#!/usr/bin/env bash

## source(s)
# shellcheck disable=SC1091
source "$HOME/bin/lib/bash-prints"
source "$HOME/bin/lib/git-clone"

## variable(s)
original="${HOME}/.dotfiles/zsh/.zshrc"
zshrc_file="${HOME}/.zshrc"
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
dependencies=(fzf git zsh)

## functions
check_fonts () {
    if ! fc-list | grep -i 'meslo.*nerd' &> /dev/null; then
        input_print "Powerlevel10k recommends Meslo Nerd Font to be installed. Do you want to install this package? (y/N): "
        read -r user_install
        case $user_install in
            y|Y ) check-pkg -r ttf-meslo-nerd ;;
            * ) info_print "Nerd Font will not be installed. ";;
        esac    
    fi
}

check_dep () {
    # iterate through dependencies
    info_print "Checking for required packages... "
    for dep in "${dependencies[@]}"; do
        check-pkg -r "$dep"
    done
}

main () {
    # check fonts
    check_fonts
    
    # install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # clone extra plugins
    git_clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    git_clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
    git_clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    git_clone https://github.com/Aloxaf/fzf-tab "$ZSH_CUSTOM/plugins/fzf-tab"
    git_clone https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

    # plugins to add to oh-my-zsh
    plugins_to_add=(branch colored-man-pages colorize command-not-found extract fzf-tab gh git safe-paste sudo zsh-autosuggestions zsh-interactive-cd zsh-syntax-highlighting)

    # add plugins
    new_plugins="plugins=(${plugins_to_add[*]})"
    sed -i "s/^plugins=.*/$new_plugins/" "$zshrc_file"

    # set powerlevel10k theme
    sed -i 's/^ZSH_THEME="[^"]*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$zshrc_file"

    # change interactive shell to zsh
    chsh -s /usr/bin/zsh

    # add .zshrc content to top of file
    sed -i "0r ${original}" "$zshrc_file"

    # append prompt to configuration
    echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> "$zshrc_file"
}

## invoke main if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if check_dep; then
        main
    fi
fi