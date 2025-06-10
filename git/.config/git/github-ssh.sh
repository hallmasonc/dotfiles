#!/usr/bin/env -S bash -e

## functions
check_dependencies() {
    if ! command -v ssh &> /dev/null && ! command -v openssl &> /dev/null && command -v gh &> /dev/null; then
        read -p "This script requires ssh, github-cli, and openssl to be installed. Do you want to install these packages? (y/N):" user_install
        case $user_install in
            y|Y )
                echo "Installing ssh, github-cli, and openssl..."
                if command -v apt &> /dev/null; then
                    sudo apt install -y ssh openssl gh
                elif command -v pacman &> /dev/null; then
                    sudo pacman -S ssh openssl github-cli
                elif command -v dnf &> /dev/null; then
                    sudo dnf install -y ssh openssl gh
                elif command -v yum &> /dev/null; then
                    sudo yum install -y ssh openssl gh
                elif command -v brew &> /dev/null; then
                    sudo brew install openssl ssh gh
                elif command -v pkg &> /dev/null; then
                    pkg install openssl ssh gh
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

check_keys() {
    if [ -f "$HOME/.ssh/*.pub" ]; then
        return 0
    else
        return 1
    fi
}

create_key() {
    local user_email
    read -p "Enter the email address associated with your GitHub account: " user_email

    if openssl list -public-key-algorithms | grep -q "ED25519"; then
        ssh-keygen -t ed25519 -C "$user_email"
    else
        ssh-keygen -t rsa -b 4096 -C "$user_email"
    fi
}

configure_agent() {
    eval "$(ssh-agent -s)"
    ssh-add $HOME/.ssh/id_ed25519
}

## main
main() {
    # Check for dependencies
    check_dependencies

    # Check for existing SSH keys
    if check_keys; then
        read -p "SSH keys already exist. Do you want to create new ones? (y/N): " user_choice
        case $user_choice in
            y|Y )
                create_key
                ;;    
            * )
                echo "Skipping key creation."
                ;;
        esac
    else
        create_key
    fi

    # Authenticate with GitHub CLI
    gh auth login

    # Configure SSH-Agent
    configure_agent
}

main
