#!/bin/bash

# Install necessary tools if they are not already installed
echo "Checking for required tools..."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect if the OS is Arch-based or Debian-based
if command_exists pacman; then
    PACKAGE_MANAGER="pacman -S --noconfirm"
    INSTALL_CMD="sudo pacman -Syu --noconfirm"
    VENV_PACKAGE="python-virtualenv"  # Arch uses python-virtualenv
    JDK_PACKAGE="jdk-openjdk"         # Arch uses jdk-openjdk instead of default-jdk
    POSTMAN_PACKAGE="postman-bin"     # Use postman-bin from AUR for Arch
    VS_CODE_PACKAGE="visual-studio-code-bin"  # VS Code from AUR
    CHROME_PACKAGE="google-chrome"           # Google Chrome from AUR    
    MATTERMOST_PACKAGE="mattermost-desktop"  # Mattermost from AUR
    TEAMS_PACKAGE="teams"                    # Microsoft Teams from AUR
    SPOTIFY_PACKAGE="spotify"                # Spotify from AUR
    INTELLIJ_PACKAGE="intellij-idea-community-edition"  # IntelliJ for Arch
    PYCHARM_PACKAGE="pycharm-community-edition"         # PyCharm for Arch
    DRACULA_KONSOLE_URL="https://raw.githubusercontent.com/dracula/konsole/master/Dracula.colorscheme"
    CHROME_PACKAGE="google-chrome"    # Use google-chrome from AUR for Arch

    # Check for an AUR helper like yay or paru
    if command_exists yay; then
        AUR_INSTALLER="yay -S --noconfirm"
    elif command_exists paru; then
        AUR_INSTALLER="paru -S --noconfirm"
    else
        echo "No AUR helper found. Please install 'yay' or 'paru' to proceed with AUR packages."
        POSTMAN_PACKAGE=""
        VS_CODE_PACKAGE=""
        CHROME_PACKAGE=""
        MATTERMOST_PACKAGE=""
        TEAMS_PACKAGE=""
        SPOTIFY_PACKAGE=""
        INTELLIJ_PACKAGE=""
        PYCHARM_PACKAGE=""
        MAILSPRING_PACKAGE=""
    fi
elif command_exists apt; then
    PACKAGE_MANAGER="apt install -y"
    INSTALL_CMD="sudo apt update && sudo apt install -y"
    VENV_PACKAGE="python3-venv"       # Debian uses python3-venv
    JDK_PACKAGE="default-jdk"         # Debian uses default-jdk
    POSTMAN_PACKAGE="postman"         # Use postman directly for Debian
    VS_CODE_PACKAGE="code"            # VS Code for Debian
    CHROME_PACKAGE="google-chrome-stable"  # Google Chrome for Debian
    MATTERMOST_PACKAGE="mattermost-desktop"  # Mattermost for Debian
    TEAMS_PACKAGE="teams"             # Microsoft Teams for Debian
    SPOTIFY_PACKAGE="spotify-client"  # Spotify for Debian
    INTELLIJ_PACKAGE="intellij-idea-community"  # IntelliJ for Debian
    PYCHARM_PACKAGE="pycharm-community"         # PyCharm for Debian
    # Spotify repository setup for Debian-based systems
    curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/spotify-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/spotify-archive-keyring.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update    
    CHROME_PACKAGE="google-chrome-stable"  # Will add Google's repository for Chrome
else
    echo "Unsupported package manager. Please use a Debian or Arch-based system."
    exit 1
fi

# Core utilities
CORE_UTILS=(ssh curl git vim python3 valgrind)
INSTALLED_CORE_UTILS=()

# Compilers
COMPILERS=(gcc "$JDK_PACKAGE")
INSTALLED_COMPILERS=()

# Development tools
DEV_UTILS=(docker "$VENV_PACKAGE" "$VS_CODE_PACKAGE")
INSTALLED_DEV_UTILS=()

# IDEs
IDEs=("$INTELLIJ_PACKAGE" "$PYCHARM_PACKAGE")
INSTALLED_IDEs=()

# API Tools
if [ -n "$POSTMAN_PACKAGE" ]; then
    API_TOOLS=(httpie "$POSTMAN_PACKAGE")
else
    API_TOOLS=(httpie)
fi
INSTALLED_API_TOOLS=()

# Entertainment
ENTERTAINMENT=("$SPOTIFY_PACKAGE")
INSTALLED_ENTERTAINMENT=()
# Additional Applications
EXTRA_APPS=("$MATTERMOST_PACKAGE" "$TEAMS_PACKAGE")
INSTALLED_EXTRA_APPS=()

# Build Tools
BUILD_TOOLS=(cmake make)
INSTALLED_BUILD_TOOLS=()

# Terminal Tools
TERMINAL_TOOLS=(tmux htop)
INSTALLED_TERMINAL_TOOLS=()

# Search and Fuzzy Find Tools
SEARCH_TOOLS=(ripgrep fzf screenfetch)
INSTALLED_SEARCH_TOOLS=()

# Browsers
if [ -n "$CHROME_PACKAGE" ]; then
    BROWSERS=("$CHROME_PACKAGE")
else
    BROWSERS=()
fi
INSTALLED_BROWSERS=()

# Email Clients
if [ -n "$MAILSPRING_PACKAGE" ]; then
    EMAIL_CLIENTS=("$MAILSPRING_PACKAGE")
else
    EMAIL_CLIENTS=()
fi
INSTALLED_EMAIL_CLIENTS=()

# Function to install missing tools with error handling
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
            $INSTALL_CMD
            for tool in "${missing_tools[@]}"; do
                if [[ "$tool" == "postman-bin" || "$tool" == "google-chrome" || "$tool" == *"intellij"* || "$tool" == *"pycharm"* || "$tool" == *"-bin"* || "$tool" == "google-chrome" || "$tool" == "teams" || "$tool" == "mattermost-desktop" || "$tool" == "spotify" ]] && [ -n "$AUR_INSTALLER" ]; then
                    $AUR_INSTALLER "$tool" || echo "Failed to install $tool from AUR."
                elif [[ "$tool" == "google-chrome-stable" ]]; then
                    # Add Google's repository and install Chrome on Debian-based systems
                    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
                    sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
                    sudo apt update
                    sudo apt install -y google-chrome-stable
                    sudo snap install mailspring
                else
                    sudo $PACKAGE_MANAGER "$tool"
                fi
            done
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
install_tools "IDEs" "${IDEs[@]}"
install_tools "API_TOOLS" "${API_TOOLS[@]}"
install_tools "BROWSERS" "${BROWSERS[@]}"
install_tools "ENTERTAINMENT" "${ENTERTAINMENT[@]}"
install_tools "EXTRA_APPS" "${EXTRA_APPS[@]}"
install_tools "BUILD_TOOLS" "${BUILD_TOOLS[@]}"
install_tools "TERMINAL_TOOLS" "${TERMINAL_TOOLS[@]}"
install_tools "SEARCH_TOOLS" "${SEARCH_TOOLS[@]}"
install_tools "BROWSERS" "${BROWSERS[@]}"
install_tools "EMAIL_CLIENTS" "${EMAIL_CLIENTS[@]}"

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

# Apply the Dracula theme to Konsole
echo "Applying Dracula theme to Konsole..."
mkdir -p ~/.local/share/konsole
wget $DRACULA_KONSOLE_URL -O ~/.local/share/konsole/Dracula.colorscheme
echo "Dracula theme for Konsole installed. Please set it manually through Konsole settings."
# Add a bash alias to .bashrc
echo "Adding a bash alias..."
if ! grep -q "alias ll='ls -alF'" ~/.bashrc; then
    echo "alias ll='ls -alF'" >> ~/.bashrc
    echo "Added alias 'll' to ~/.bashrc"

# Vim Installation and Configuration
read -p "Do you want to install and configure Vim? [y/N] " vim_install
if [[ "$vim_install" =~ ^[Yy]$ ]]; then
    mkdir -p "$HOME/.config/vim"
    echo "Created vim configuration directory."
    mkdir -p "$HOME/.config/vim/autoload"

    if [ ! -f "$HOME/.config/vim/autoload/plug.vim" ]; then
        echo "Installing vim-plug..."
        if ! curl -fLo "$HOME/.config/vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
            echo "Failed to install vim-plug. Exiting..."
            exit 1
        fi
        echo "vim-plug installed."
    else
        echo "vim-plug is already installed."
    fi

    # Check if jbras.vim exists in the script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -f "$SCRIPT_DIR/.config/vim/jbras.vim" ]; then
        cp "$SCRIPT_DIR/.config/vim/jbras.vim" "$HOME/.config/vim"
        echo "Copied vim configuration file: jbras.vim"
    else
        echo "jbras.vim not found in $SCRIPT_DIR/.config/vim. Creating a default configuration."
        echo "\" Default Vim configuration" > "$HOME/.config/vim/jbras.vim"
    fi
    VIM_CONFIG="$HOME/.config/vim/jbras.vim"

    {
        echo "set runtimepath+=~/.config/vim"
        echo "source $VIM_CONFIG"
        echo "call plug#begin('~/.config/vim/plugged')"
        echo "Plug 'mattn/vim-rsync'"
        echo "call plug#end()"
    } > "$HOME/.vimrc"

    {
        echo "let g:rsync#remote = {"
        echo "    \ 'host': 'user@yourserver.com',"
        echo "    \ 'port': 22,"
        echo "    \ 'path': '/path/to/remote/directory',"
        echo "    \ }"
    } >> "$VIM_CONFIG"

    VIM_COLOR_DIR="$HOME/.config/vim/colors"
    mkdir -p "$VIM_COLOR_DIR"
    echo "Downloading Dracula color scheme..."
    if curl -o "$VIM_COLOR_DIR/dracula.vim" https://raw.githubusercontent.com/dracula/vim/master/colors/dracula.vim; then
        echo "Dracula color scheme downloaded."
    else
        echo "Error: Failed to download the Dracula color scheme."
        exit 1
    fi
    echo "Setup complete! Please restart Vim and run :PlugInstall to install vim-rsync."
else
    echo "Skipping Vim installation."
fi

echo -e "\n### Summary of Installed Tools ###"
for category in "CORE_UTILS" "COMPILERS" "DEV_UTILS" "API_TOOLS" "BUILD_TOOLS" "TERMINAL_TOOLS" "SEARCH_TOOLS" "BROWSERS" "EMAIL_CLIENTS"; do
    installed_var="INSTALLED_$category[@]"
    if [ ${#installed_var} -ne 0 ]; then
        echo "${category//_/ }: ${!installed_var}"
    fi
done

# bashrc SSH agent addition
if ! grep -q "eval \"\$(ssh-agent -s)\"" "$HOME/.bashrc"; then
    echo -e "\n# Start SSH agent" >> "$HOME/.bashrc"
    echo 'eval "$(ssh-agent -s)"' >> "$HOME/.bashrc"
    read -p "Enter your SSH key path (default: ~/.ssh/github_jbras_sea_ai): " ssh_key
    ssh_key=${ssh_key:-~/.ssh/github_jbras_sea_ai}
    echo "ssh-add $ssh_key" >> "$HOME/.bashrc"
    echo "SSH agent initialization added to .bashrc."
else
    echo "SSH agent initialization already exists in .bashrc."
fi

