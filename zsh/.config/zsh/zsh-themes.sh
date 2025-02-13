#!/usr/bin/env bash

# Variables
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
zshrc_file="${HOME}/.zshrc"

# Cosmetics (colors for text).
BOLD='\e[1m'
BRED='\e[91m'
BBLUE='\e[34m'  
BGREEN='\e[92m'
BYELLOW='\e[93m'
RESET='\e[0m'

# Pretty print (function).
info_print () {
    echo -e "${BOLD}${BGREEN}[ ${BYELLOW}•${BGREEN} ] $1${RESET}"
}

# Pretty print for input (function).
input_print () {
    echo -ne "${BOLD}${BYELLOW}[ ${BGREEN}•${BYELLOW} ] $1${RESET}"
}

# Alert user of bad input (function).
error_print () {
    echo -e "${BOLD}${BRED}[ ${BBLUE}•${BRED} ] $1${RESET}"
}

# warn to exit zsh after oh-my-zsh install
info_print "Type 'exit' after the oh-my-zsh install is complete"

# install oh-my-zsh (this prompts to change the default shell in it isn't zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# clone extra plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# plugins to add to oh-my-zsh
plugins_to_add=("branch" "colored-man-pages" "colorize" "command-not-found" "extract" "gh" "git" "safe-paste" "sudo" "zsh-autosuggestions" "zsh-interactive-cd" "zsh-syntax-highlighting")

# add plugins
new_plugins="plugins=(${plugins_to_add[@]})"
sed -i -e "s/^plugins=.*/$new_plugins/" $zshrc_file

# clone powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}/themes/powerlevel10k"

# set powerlevel10k theme
sed -i.bak -e 's/^ZSH_THEME="[^"]*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' $zshrc_file