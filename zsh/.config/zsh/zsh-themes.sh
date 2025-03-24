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
# pretty print
info_print () {
    echo -e "${BOLD}${BGREEN}[ ${BYELLOW}•${BGREEN} ] $1${RESET}"
    echo ""
}
# git clone
gc () {
    git clone --depth=1 $1 $2
    info_print "Cloning into ${$2}"
}

# Check required packages
if command -v zsh &> /dev/null && command -v git &> /dev/null && command -v fzf &> /dev/null; then
    info_print "zsh, fzf, and git are already installed"
else
    if sudo pacman -S zsh fzf git; then
        info_print "zsh, fzf, and git are now installed"
    else
        info_print "Please install the required packages before running this script: zsh, fzf, and git" && exit
    fi
fi

# check required font for powerlevel10k
if fc-list | grep -i 'meslo.*nerd' &> /dev/null; then
    info_print "Meslo Nerd Font is installed"
else
    if sudo pacman -S ttf-meslo-nerd; then
        info_print "Meslo Nerd Font is now installed"
    else
        info_print "Please install the recommended font for powerlevel10k"
    fi
fi

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# clone extra plugins
gc https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
gc https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
gc https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
gc https://github.com/Aloxaf/fzf-tab $ZSH_CUSTOM/plugins/fzf-tab
gc https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# plugins to add to oh-my-zsh
plugins_to_add=("branch" "colored-man-pages" "colorize" "command-not-found" "extract" "fzf-tab" "gh" "git" "safe-paste" "sudo" "zsh-autosuggestions" "zsh-interactive-cd" "zsh-syntax-highlighting")

# add plugins
new_plugins="plugins=(${plugins_to_add[@]})"
sed -i "s/^plugins=.*/$new_plugins/" $zshrc_file

# set powerlevel10k theme
sed -i 's/^ZSH_THEME="[^"]*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' $zshrc_file

# change interactive shell to zsh
chsh -s $(which zsh)

# add .zshrc content to top of file
sed -i "0r ${original}" $zshrc_file