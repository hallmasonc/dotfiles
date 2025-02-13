#!/usr/bin/env bash

## variables
original="${HOME}/.zshrc.pre-oh-my-zsh"
zshrc_file="${HOME}/.zshrc"
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"

# Cosmetics (colors for text).
BOLD='\e[1m'
BRED='\e[91m'
BBLUE='\e[34m'  
BGREEN='\e[92m'
BYELLOW='\e[93m'
RESET='\e[0m'

## functions
# git clone
gc () {
    info_print "Cloning into: ${2}"
    git clone $1 $2
}
# pretty print
info_print () {
    echo -e "${BOLD}${BGREEN}[ ${BYELLOW}•${BGREEN} ] $1${RESET}"
    echo ""
}

# warn to exit zsh after oh-my-zsh install
info_print "Type 'exit' after the oh-my-zsh install is complete."

# install oh-my-zsh (prompts to change the default shell if not zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# clone extra plugins
gc https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
gc https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
gc https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
gc https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"

# plugins to add to oh-my-zsh
plugins_to_add=("branch" "colored-man-pages" "colorize" "command-not-found" "extract" "gh" "git" "safe-paste" "sudo" "zsh-autosuggestions" "zsh-interactive-cd" "zsh-syntax-highlighting")

# add plugins
new_plugins="plugins=(${plugins_to_add[@]})"
sed -i "s/^plugins=.*/$new_plugins/" $zshrc_file

# set powerlevel10k theme
sed -i 's/^ZSH_THEME="[^"]*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' $zshrc_file

# start zsh to configure powerlevel10k
zsh

# add .zshrc content to top of file
sed -i "1r ${original}" $zshrc_file

# clear .bashrc
truncate -s 0 ~/.bashrc