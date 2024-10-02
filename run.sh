#!/bin/bash

# Install necessary tools if they are not already installed
echo "Checking for required tools..."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Core utilities
CORE_UTILS=(ssh curl git vim python3 valgrind)
INSTALLED_CORE_UTILS=()

# Compilers
COMPILERS=(gcc default-jdk)
INSTALLED_COMPILERS=()

# Development tools
DEV_UTILS=(docker python3-venv)
INSTALLED_DEV_UTILS=()

# API Tools
API_TOOLS=(postman httpie)
INSTALLED_API_TOOLS=()

# Build Tools
BUILD_TOOLS=(cmake make)
INSTALLED_BUILD_TOOLS=()

# Terminal Tools
TERMINAL_TOOLS=(tmux htop)
INSTALLED_TERMINAL_TOOLS=()

# Search and Fuzzy Find Tools
SEARCH_TOOLS=(ripgrep fzf screenfetch)
INSTALLED_SEARCH_TOOLS=()

# Function to install missing tools
install_tools() {
    local tool_category="$1"
    shift
    local tools=("$@")
    
    missing_tools=()
    for tool in "${tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_tools+=("$tool")
        else
            eval "INSTALLED_${tool_category}+=('$tool')"
        fi
    done

    if [ ${#missing_tools[@]} -ne 0 ]; then
        read -p "Do you want to install missing ${tool_category//_/ }? (${missing_tools[*]}): [y/N] " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            echo "Installing missing ${tool_category//_/ }: ${missing_tools[*]}..."
            sudo apt update
            sudo apt install -y "${missing_tools[@]}"
        else
            echo "Skipping installation of missing ${tool_category//_/ }."
        fi
    else
        echo "All ${tool_category//_/ } are already installed."
    fi
}

# Check and install tools
install_tools "CORE_UTILS" "${CORE_UTILS[@]}"
install_tools "COMPILERS" "${COMPILERS[@]}"
install_tools "DEV_UTILS" "${DEV_UTILS[@]}"
install_tools "API_TOOLS" "${API_TOOLS[@]}"
install_tools "BUILD_TOOLS" "${BUILD_TOOLS[@]}"
install_tools "TERMINAL_TOOLS" "${TERMINAL_TOOLS[@]}"
install_tools "SEARCH_TOOLS" "${SEARCH_TOOLS[@]}"

# Git Configuration
read -p "Do you want to configure Git? [y/N] " git_configure
if [[ "$git_configure" =~ ^[Yy]$ ]]; then
    echo "Configuring Git account..."
    read -p "Enter your Git username: " git_username
    read -p "Enter your Git email: " git_email

    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    echo "Git configured with username '$git_username' and email '$git_email'."
else
    echo "Skipping Git configuration."
fi

# Vim Installation and Configuration
read -p "Do you want to install and configure Vim? [y/N] " vim_install
if [[ "$vim_install" =~ ^[Yy]$ ]]; then
    ## Create the vim configuration directory
    mkdir -p "$HOME/.config/vim"
    echo "Created vim configuration directory."

    ## Create the autoload directory for vim-plug
    mkdir -p "$HOME/.config/vim/autoload"
    
    # Install vim-plug if not already installed
    if [ ! -f "$HOME/.config/vim/autoload/plug.vim" ]; then
        echo "Installing vim-plug..."
        curl -fLo "$HOME/.config/vim/autoload/plug.vim" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        echo "vim-plug installed."
    else
        echo "vim-plug is already installed."
    fi

    ## Create the .vimrc file in the home directory
    {
        echo "set runtimepath+=~/.config/vim"
        echo "source ~/.config/vim/jbras.vim"  # Point to your custom config file
        echo "call plug#begin('~/.config/vim/plugged')"
        echo "Plug 'mattn/vim-rsync'"  # Add vim-rsync plugin
        echo "call plug#end()"
    } > "$HOME/.vimrc"

    echo ".vimrc created and configured to include vim-rsync and your custom config."

    # Configuration for vim-rsync
    {
        echo "let g:rsync#remote = {"
        echo "    \ 'host': 'user@yourserver.com',"
        echo "    \ 'port': 22,"
        echo "    \ 'path': '/path/to/remote/directory',"
        echo "    \ }"
    } >> "$HOME/.vimrc"

    echo "vim-rsync configuration added to .vimrc."

    # Define the destination directory for Vim color schemes
    VIM_COLOR_DIR="$HOME/.config/vim/colors"

    # Create the directory if it doesn't exist
    mkdir -p "$VIM_COLOR_DIR"

    # Download the Dracula color scheme
    curl -o "$VIM_COLOR_DIR/dracula.vim" https://raw.githubusercontent.com/dracula/vim/master/colors/dracula.vim
    echo "Dracula color scheme downloaded."

    # Check if the colorscheme file was downloaded successfully
    if [ -f "$VIM_COLOR_DIR/dracula.vim" ]; then
        echo "Setup complete! Please restart Vim and run :PlugInstall to install vim-rsync."
    else
        echo "Error: Failed to download the Dracula color scheme."
    fi
else
    echo "Skipping Vim installation."
fi

# Summary of installed tools
echo -e "\n### Summary of Installed Tools ###"

for category in "CORE_UTILS" "COMPILERS" "DEV_UTILS" "API_TOOLS" "BUILD_TOOLS" "TERMINAL_TOOLS" "SEARCH_TOOLS"; do
    if [ ${#INSTALLED_$category[@]} -ne 0 ]; then
        echo "${category//_/ }: ${!category[*]}"
    fi
done

# bashrc
## Check if SSH agent initialization is already in .bashrc
if ! grep -q "eval \"\$(ssh-agent -s)\"" "$HOME/.bashrc"; then
    echo -e "\n# Start SSH agent" >> "$HOME/.bashrc"
    echo 'eval "$(ssh-agent -s)"' >> "$HOME/.bashrc"
    echo "ssh-add ~/.ssh/github_jbras_sea_ai" >> "$HOME/.bashrc" # Modify this line for your key if needed
    echo "SSH agent initialization added to .bashrc."
else
    echo "SSH agent initialization already exists in .bashrc."
fi

