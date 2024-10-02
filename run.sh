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
echo "Configuring Git account..."
read -p "Enter your Git username: " git_username
read -p "Enter your Git email: " git_email

git config --global user.name "$git_username"
git config --global user.email "$git_email"
echo "Git configured with username '$git_username' and email '$git_email'."

# Vim Installation and Configuration
read -p "Do you want to install and configure Vim? [y/N] " vim_install
if [[ "$vim_install" =~ ^[Yy]$ ]]; then
    ## Create the vim configuration directory
    mkdir -p "$HOME/.config/vim"
    echo "Created vim configuration directory."

    ## Copies my vim config into the appropriate directory
    cp .config/vim/jbras.vim "$HOME/.config/vim"
    echo "Copied vim configuration file."

    ## Define the path to the Vim configuration file
    VIM_CONFIG="$HOME/.config/vim/jbras.vim"

    ## Create the .vimrc file in the home directory
    {
        echo "set runtimepath+=~/.config/vim"
        echo "source $VIM_CONFIG"
    } > "$HOME/.vimrc"

    echo ".vimrc created and configured to point to $VIM_CONFIG."

    # Define the destination directory for Vim color schemes
    VIM_COLOR_DIR="$HOME/.config/vim/colors"

    # Create the directory if it doesn't exist
    mkdir -p "$VIM_COLOR_DIR"

    # Download the Dracula color scheme
    curl -o "$VIM_COLOR_DIR/dracula.vim" https://raw.githubusercontent.com/dracula/vim/master/colors/dracula.vim
    echo "Dracula color scheme downloaded."

    # Check if the colorscheme file was downloaded successfully
    if [ -f "$VIM_COLOR_DIR/dracula.vim" ]; then
        echo "Setup complete! Please restart Vim to see the changes."
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

