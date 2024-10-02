#!/bin/bash

# Install necessary tools if they are not already installed
echo "Checking for required tools..."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Core utilities
CORE_UTILS=(ssh curl git vim python3 valgrind)

# Compilers
COMPILERS=(gcc default-jdk)

# Development tools
DEV_UTILS=(docker python3-venv)

# API Tools
API_TOOLS=(postman httpie)

# Build Tools
BUILD_TOOLS=(cmake make)

# Terminal Tools
TERMINAL_TOOLS=(tmux htop)

# Search and Fuzzy Find Tools
SEARCH_TOOLS=(ripgrep fzf fastfetch)

# Install core utilities if they are missing
missing_utils=()
for tool in "${CORE_UTILS[@]}"; do
    if ! command_exists "$tool"; then
        missing_utils+=("$tool")
    fi
done

if [ ${#missing_utils[@]} -ne 0 ]; then
    echo "Installing missing core utilities: ${missing_utils[*]}..."
    sudo apt update
    sudo apt install -y "${missing_utils[@]}"
else
    echo "All core utilities are already installed."
fi

# Install compilers if they are missing
missing_compilers=()
for compiler in "${COMPILERS[@]}"; do
    if ! command_exists "$compiler"; then
        missing_compilers+=("$compiler")
    fi
done

if [ ${#missing_compilers[@]} -ne 0 ]; then
    echo "Installing missing compilers: ${missing_compilers[*]}..."
    sudo apt install -y "${missing_compilers[@]}"
else
    echo "All compilers are already installed."
fi

# Install development tools if they are missing
missing_dev_utils=()
for tool in "${DEV_UTILS[@]}"; do
    if ! command_exists "$tool"; then
        missing_dev_utils+=("$tool")
    fi
done

if [ ${#missing_dev_utils[@]} -ne 0 ]; then
    echo "Installing missing development tools: ${missing_dev_utils[*]}..."
    sudo apt install -y "${missing_dev_utils[@]}"
else
    echo "All development tools are already installed."
fi

# Install API tools if they are missing
missing_api_tools=()
for tool in "${API_TOOLS[@]}"; do
    if ! command_exists "$tool"; then
        missing_api_tools+=("$tool")
    fi
done

if [ ${#missing_api_tools[@]} -ne 0 ]; then
    echo "Installing missing API tools: ${missing_api_tools[*]}..."
    sudo apt install -y "${missing_api_tools[@]}"
else
    echo "All API tools are already installed."
fi

# Install build tools if they are missing
missing_build_tools=()
for tool in "${BUILD_TOOLS[@]}"; do
    if ! command_exists "$tool"; then
        missing_build_tools+=("$tool")
    fi
done

if [ ${#missing_build_tools[@]} -ne 0 ]; then
    echo "Installing missing build tools: ${missing_build_tools[*]}..."
    sudo apt install -y "${missing_build_tools[@]}"
else
    echo "All build tools are already installed."
fi

# Install terminal tools if they are missing
missing_terminal_tools=()
for tool in "${TERMINAL_TOOLS[@]}"; do
    if ! command_exists "$tool"; then
        missing_terminal_tools+=("$tool")
    fi
done

if [ ${#missing_terminal_tools[@]} -ne 0 ]; then
    echo "Installing missing terminal tools: ${missing_terminal_tools[*]}..."
    sudo apt install -y "${missing_terminal_tools[@]}"
else
    echo "All terminal tools are already installed."
fi

# Install search and fuzzy find tools if they are missing
missing_search_tools=()
for tool in "${SEARCH_TOOLS[@]}"; do
    if ! command_exists "$tool"; then
        missing_search_tools+=("$tool")
    fi
done

if [ ${#missing_search_tools[@]} -ne 0 ]; then
    echo "Installing missing search and fuzzy find tools: ${missing_search_tools[*]}..."
    sudo apt install -y "${missing_search_tools[@]}"
else
    echo "All search and fuzzy find tools are already installed."
fi

# Vim

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

