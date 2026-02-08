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
    info_print "Cloning into $2"
    git clone --depth=1 $1 $2
}

# Check required packages
check_dependencies() {
    if ! command -v zsh &> /dev/null && ! command -v fzf &> /dev/null && ! command -v git &> /dev/null; then
        read -p "This script requires zsh, fzf, and git to be installed. Do you want to install these packages? (y/N):" user_install
        case $user_install in
            y|Y )
                echo "Installing zsh, fzf, and git..."
                if command -v apt &> /dev/null; then
                    sudo apt install -y zsh fzf git
                elif command -v pacman &> /dev/null; then
                    sudo pacman -S zsh fzf git
                elif command -v dnf &> /dev/null; then
                    sudo dnf install -y zsh fzf git
                elif command -v yum &> /dev/null; then
                    sudo yum install -y zsh fzf git
                elif command -v brew &> /dev/null; then
                    sudo brew install zsh fzf git
                elif command -v pkg &> /dev/null; then
                    pkg install zsh fzf git
                else
                    echo "No suitable package manager found. Exiting script."
                    exit 1
                fi
                ;;
            * )
                echo "Packages will not be installed. Exiting script."
                exit 1
                ;;
        esac
    fi
}

# check fonts
check_fonts() {
    if ! fc-list | grep -i 'meslo.*nerd' &> /dev/null; then
        read -p "Powerlevel10k recommends Meslo Nerd Font to be installed. Do you want to install this package? (y/N):" user_install
        case $user_install in
            y|Y )
                echo "Installing Meslo Nerd Font..."
                if command -v apt &> /dev/null; then
                    sudo apt install -y fonts-meslo-nerd
                elif command -v pacman &> /dev/null; then
                    sudo pacman -S ttf-meslo-nerd
                elif command -v dnf &> /dev/null; then
                    sudo dnf install -y meslo-nerd-fonts
                elif command -v yum &> /dev/null; then
                    sudo yum install -y meslo-nerd-fonts
                elif command -v brew &> /dev/null; then
                    sudo brew install meslo-nerd-font
                elif command -v pkg &> /dev/null; then
                    pkg install meslo-nerd-font
                else
                    echo "No suitable package manager found. Exiting script."
                    exit 1
                fi
                ;;
            * )
                echo "Packages will not be installed. Exiting script."
                exit 1
                ;;
        esac
    else
        info_print "Meslo Nerd Font is installed"
    fi
}

main () {
    # check dependencies
    check_dependencies

    # check fonts
    check_fonts
    
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
    chsh -s /usr/bin/zsh

    # add .zshrc content to top of file
    sed -i "0r ${original}" $zshrc_file
}

main