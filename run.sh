#!/bin/zsh

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Set Zsh configuration file
CONFIG_FILE="$HOME/.zshrc"
echo "Using configuration file: $CONFIG_FILE"

# Function to add alias to config file
add_alias() {
    local alias_cmd="$1"
    if ! grep -q "$alias_cmd" "$CONFIG_FILE"; then
        echo "$alias_cmd" | tee -a "$CONFIG_FILE" > /dev/null
        echo "Added alias to $CONFIG_FILE: $alias_cmd"
    else
        echo "Alias already exists in $CONFIG_FILE: $alias_cmd"
    fi
}

# Function to add SSH agent initialization
add_ssh_agent() {
    if ! grep -q "eval \"\$(ssh-agent -s)\"" "$CONFIG_FILE"; then
        echo -e "\n# Start SSH agent" | tee -a "$CONFIG_FILE" > /dev/null
        echo 'eval "$(ssh-agent -s)"' | tee -a "$CONFIG_FILE" > /dev/null
        read -p "Enter your SSH key path (default: ~/.ssh/id_rsa): " ssh_key
        ssh_key=${ssh_key:-~/.ssh/id_rsa}
        if [ -f "$ssh_key" ]; then
            echo "Adding SSH key to agent..."
            echo "ssh-add $ssh_key" | tee -a "$CONFIG_FILE" > /dev/null
            echo "SSH agent initialization added to $CONFIG_FILE."
        else
            echo "SSH key not found at $ssh_key. Please generate it using 'ssh-keygen'."
        fi
    else
        echo "SSH agent initialization already exists in $CONFIG_FILE."
    fi
}

# Add a shell alias
echo "Adding a shell alias..."
add_alias "alias ll='ls -alF'"

# Add custom PS1 prompt to Zsh
if ! grep -q "export PS1=" "$CONFIG_FILE"; then
    echo 'export PS1="%F{green}%n@%m %F{blue}%~%f $ "' | tee -a "$CONFIG_FILE" > /dev/null
    echo "Custom PS1 prompt added to $CONFIG_FILE."
else
    echo "PS1 prompt already customized in $CONFIG_FILE."
fi

# SSH Agent Configuration
echo "Configuring SSH agent..."
add_ssh_agent

echo "Finished environment setup procedures"

# Detect if the OS is Arch-based or Debian-based
if command_exists pacman; then
    PACKAGE_MANAGER="pacman -S --noconfirm"
    INSTALL_CMD="sudo pacman -Syu --noconfirm"
    VENV_PACKAGE="python-virtualenv"  # Arch uses python-virtualenv
    JDK_PACKAGE="jdk-openjdk"         # Arch uses jdk-openjdk instead of default-jdk
    POSTMAN_PACKAGE="postman-bin"     # Use postman-bin from AUR for Arch
    VS_CODE_PACKAGE="visual-studio-code-bin"  # VS Code from AUR
    CHROME_PACKAGE="google-chrome"    # Google Chrome from AUR
    MATTERMOST_PACKAGE="mattermost-desktop"  # Mattermost from AUR
    TEAMS_PACKAGE="teams"                    # Microsoft Teams from AUR
    SPOTIFY_PACKAGE="spotify"                # Spotify from AUR
    INTELLIJ_PACKAGE="intellij-idea-community-edition"  # IntelliJ for Arch
    PYCHARM_PACKAGE="pycharm-community-edition"         # PyCharm for Arch
    EMAIL_CLIENT_PACKAGE="kmail"             # KMail for Arch
    ZOOM_PACKAGE="zoom"                      # Zoom from AUR
    OBSIDIAN_PACKAGE="obsidian"              # Obsidian from AUR
    DRACULA_KONSOLE_URL="https://raw.githubusercontent.com/dracula/konsole/master/Dracula.colorscheme"

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
        EMAIL_CLIENT_PACKAGE=""
        ZOOM_PACKAGE=""
        OBSIDIAN_PACKAGE=""
    fi
elif command_exists apt; then
    PACKAGE_MANAGER="apt install -y"
    INSTALL_CMD="sudo apt update && sudo apt install -y"
    VENV_PACKAGE="python3-venv"       # Debian uses python3-venv
    JDK_PACKAGE="default-jdk"         # Debian uses default-jdk
    POSTMAN_PACKAGE=""                # Postman installation handled separately
    VS_CODE_PACKAGE="code"            # VS Code for Debian
    CHROME_PACKAGE="google-chrome-stable"  # Google Chrome for Debian
    MATTERMOST_PACKAGE="mattermost-desktop"  # Mattermost for Debian
    TEAMS_PACKAGE="teams"             # Microsoft Teams for Debian
    SPOTIFY_PACKAGE="spotify-client"  # Spotify for Debian
    INTELLIJ_PACKAGE="intellij-idea-community"  # IntelliJ for Debian
    PYCHARM_PACKAGE="pycharm-community"         # PyCharm for Debian
    EMAIL_CLIENT_PACKAGE="kmail"      # KMail for Debian
    ZOOM_PACKAGE="zoom"               # Zoom for Debian
    OBSIDIAN_PACKAGE="obsidian"       # Obsidian AppImage or .deb

    # Spotify repository setup for Debian-based systems
    if ! grep -q "spotify" /etc/apt/sources.list.d/* 2>/dev/null; then
        curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/spotify-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/spotify-archive-keyring.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    fi

    # Add Google's repository for Chrome
    if ! grep -q "dl.google.com/linux/chrome/deb/" /etc/apt/sources.list.d/* 2>/dev/null; then
        wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
        echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    fi

    # Zoom repository setup for Debian-based systems
    if ! grep -q "zoom" /etc/apt/sources.list.d/* 2>/dev/null; then
        wget -O- https://zoom.us/linux/download/pubkey | sudo apt-key add -
        echo "deb [arch=amd64] https://zoom.us/linux/debian stable main" | sudo tee /etc/apt/sources.list.d/zoom.list
    fi

    sudo apt update
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
API_TOOLS=(httpie)
[ -n "$POSTMAN_PACKAGE" ] && API_TOOLS+=("$POSTMAN_PACKAGE")
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
BROWSERS=()
[ -n "$CHROME_PACKAGE" ] && BROWSERS+=("$CHROME_PACKAGE")
INSTALLED_BROWSERS=()

# Email Clients
EMAIL_CLIENTS=("$EMAIL_CLIENT_PACKAGE")
INSTALLED_EMAIL_CLIENTS=()

# Video Conferencing Tools
VIDEO_CONFERENCING=("$ZOOM_PACKAGE")
INSTALLED_VIDEO_CONFERENCING=()

# Notes Applications
NOTES_APPS=("$OBSIDIAN_PACKAGE")
INSTALLED_NOTES_APPS=()

# Function to install missing tools with error handling
install_tools() {
    local tool_category="$1"
    shift
    local tools=("$@")
    local missing_tools=()

    for tool in "${tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_tools+=("$tool")
        else
            eval "INSTALLED_${tool_category}+=('$tool')"
        fi
    done

    if [ ${#missing_tools[@]} -ne 0 ]; then
        read -p "Do you want to install missing ${tool_category//_/ }? (${missing_tools[*]}): [Y/n] " answer
        answer=${answer:-Y}
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            echo "Installing missing ${tool_category//_/ }: ${missing_tools[*]}..."
            # Update repositories only once per installation
            if [ "$INSTALL_CMD_RUN" != "true" ]; then
                $INSTALL_CMD
                INSTALL_CMD_RUN="true"
            fi
            for tool in "${missing_tools[@]}"; do
                if [[ "$tool" == "postman-bin" || "$tool" == *"-bin" || "$tool" == "$CHROME_PACKAGE" || "$tool" == "teams" || "$tool" == "mattermost-desktop" || "$tool" == "spotify" || "$tool" == "$INTELLIJ_PACKAGE" || "$tool" == "$PYCHARM_PACKAGE" || "$tool" == "$EMAIL_CLIENT_PACKAGE" || "$tool" == "$ZOOM_PACKAGE" || "$tool" == "$OBSIDIAN_PACKAGE" ]] && [ -n "$AUR_INSTALLER" ]; then
                    echo "Installing $tool from AUR..."
                    if ! $AUR_INSTALLER "$tool"; then
                        echo "Failed to install $tool from AUR."
                    fi
                elif [[ "$tool" == "google-chrome-stable" ]]; then
                    echo "Installing Google Chrome..."
                    sudo apt install -y google-chrome-stable
                elif [[ "$tool" == "zoom" && "$PACKAGE_MANAGER" == "apt install -y" ]]; then
                    echo "Installing Zoom..."
                    sudo apt install -y zoom
                elif [[ "$tool" == "obsidian" ]]; then
                    echo "Installing Obsidian..."
                    if [ "$PACKAGE_MANAGER" == "apt install -y" ]; then
                        OBSIDIAN_DEB_URL=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep "browser_download_url.*amd64.deb" | cut -d '"' -f 4)
                        wget "$OBSIDIAN_DEB_URL" -O /tmp/obsidian.deb
                        sudo dpkg -i /tmp/obsidian.deb
                        sudo apt -f install -y
                        rm /tmp/obsidian.deb
                    elif [ -n "$AUR_INSTALLER" ]; then
                        $AUR_INSTALLER obsidian
                    fi
                else
                    echo "Installing $tool..."
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

# Initialize INSTALL_CMD_RUN variable
INSTALL_CMD_RUN="false"

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
install_tools "EMAIL_CLIENTS" "${EMAIL_CLIENTS[@]}"
install_tools "VIDEO_CONFERENCING" "${VIDEO_CONFERENCING[@]}"
install_tools "NOTES_APPS" "${NOTES_APPS[@]}"

# Git Configuration
read -p "Do you want to configure Git? [Y/n] " git_configure
git_configure=${git_configure:-Y}
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

# Apply the Dracula theme to Konsole (only if Konsole is installed)
if command_exists konsole; then
    echo "Applying Dracula theme to Konsole..."
    mkdir -p ~/.local/share/konsole
    if wget -q "$DRACULA_KONSOLE_URL" -O ~/.local/share/konsole/Dracula.colorscheme; then
        echo "Dracula theme for Konsole installed. Please set it manually through Konsole settings."
    else
        echo "Failed to download Dracula theme for Konsole."
    fi
else
    echo "Konsole is not installed. Skipping Dracula theme application."
fi

# Vim Installation and Configuration
read -p "Do you want to install and configure Vim? [Y/n] " vim_install
vim_install=${vim_install:-Y}
if [[ "$vim_install" =~ ^[Yy]$ ]]; then
    echo "Configuring Vim..."
    mkdir -p "$HOME/.vim/autoload" "$HOME/.vim/plugged"
    VIM_AUTOLOAD_DIR="$HOME/.vim/autoload"

    if [ ! -f "$VIM_AUTOLOAD_DIR/plug.vim" ]; then
        echo "Installing vim-plug..."
        if ! curl -fLo "$VIM_AUTOLOAD_DIR/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
            echo "Failed to install vim-plug. Exiting..."
            exit 1
        fi
        echo "vim-plug installed."
    else
        echo "vim-plug is already installed."
    fi

    # Backup existing .vimrc if it exists
    if [ -f "$HOME/.vimrc" ]; then
        cp "$HOME/.vimrc" "$HOME/.vimrc.bak"
        echo "Backed up existing .vimrc to .vimrc.bak"
    fi

    # Create .vimrc
    {
        echo "\" Begin Vim configuration"
        echo "call plug#begin('~/.vim/plugged')"
        echo "Plug 'dracula/vim', { 'as': 'dracula' }"
        echo "Plug 'mattn/vim-rsync'"
        echo "call plug#end()"
        echo "syntax on"
        echo "set number"
        echo "set termguicolors"
        echo "colorscheme dracula"
    } > "$HOME/.vimrc"

    echo "Installing Vim plugins..."
    vim +PlugInstall +qall

    echo "Vim configuration complete!"
else
    echo "Skipping Vim installation."
fi

echo -e "\n### Summary of Installed Tools ###"
for category in "CORE_UTILS" "COMPILERS" "DEV_UTILS" "IDEs" "API_TOOLS" "BUILD_TOOLS" "TERMINAL_TOOLS" "SEARCH_TOOLS" "BROWSERS" "ENTERTAINMENT" "EXTRA_APPS" "EMAIL_CLIENTS" "VIDEO_CONFERENCING" "NOTES_APPS"; do
    installed_var="INSTALLED_$category[@]"
    installed_tools=("${!installed_var}")
    if [ ${#installed_tools[@]} -ne 0 ]; then
        echo "${category//_/ }: ${installed_tools[*]}"
    fi
done

echo "Finished environment setup procedures"
exit 0

