#!/bin/zsh

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Set Zsh configuration file
CONFIG_FILE="$HOME/.zshrc"
echo "Using configuration file: $CONFIG_FILE"

# Function to add content to config file if not already present
add_to_config() {
    local content="$1"
    local description="$2"
    if ! grep -q "$content" "$CONFIG_FILE"; then
        echo "$content" | tee -a "$CONFIG_FILE" > /dev/null
        echo "$description added to $CONFIG_FILE."
    else
        echo "$description already exists in $CONFIG_FILE."
    fi
}

# Function to detect if running on Manjaro
is_manjaro() {
    if [[ -f /etc/manjaro-release ]]; then
        return 0
    else
        return 1
    fi
}

# Apply Zsh configs and prompting. If on Manjaro apply default settings
apply_zsh_configs_prompt() {
    if is_manjaro; then
        echo "Detected Manjaro system. Applying Manjaro-specific Zsh configurations..."
        # Example Manjaro-specific configurations
        add_to_config 'source /usr/share/zsh/manjaro-zsh-config' "Manjaro Zsh configuration"
        add_to_config 'source /usr/share/zsh/manjaro-zsh-prompt' "Manjaro Zsh prompt"
        add_to_config 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' "Zsh Syntax Highlighting Plugin"
        add_to_config 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' "Zsh Autosuggestions Plugin"
    else
        echo "Adding color aliases..."
        add_to_config "alias ls='ls --color=auto'" "Color alias for ls"
        add_to_config "alias grep='grep --color=auto'" "Color alias for grep"
        add_to_config "alias egrep='egrep --color=auto'" "Color alias for egrep"
        add_to_config "alias fgrep='fgrep --color=auto'" "Color alias for fgrep"
        add_to_config "alias diff='diff --color=auto'" "Color alias for diff"
        add_to_config "alias tail='tail --color=always'" "Color alias for tail"
        add_to_config "alias dmesg='dmesg --color=always'" "Color alias for dmesg"

        # Add Zsh prompt customization
        echo "Adding custom PS1 prompt..."
        add_to_config 'export PS1="%F{green}%n@%m %F{blue}%~%f $ "' "Custom PS1 prompt"

        # Enable LS_COLORS for more vibrant colors when using ls
        echo "Enabling LS_COLORS..."  
        add_to_config 'export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=37;40:cd=37;40:su=37;41:sg=37;46:tw=37;42:ow=37;43"' "LS_COLORS configuration"
    fi
}

# Apply Zsh config and prompt
echo "Applying Zsh config and prompt..."
apply_zsh_configs_prompt

# Function to add SSH agent initialization
add_ssh_agent() {
    if ! grep -q "eval \"\$(ssh-agent -s)\"" "$CONFIG_FILE"; then
        echo -e "\n# Start SSH agent" | tee -a "$CONFIG_FILE" > /dev/null
        echo 'eval "$(ssh-agent -s)"' | tee -a "$CONFIG_FILE" > /dev/null
        printf "Enter your SSH key path (default: ~/.ssh/id_rsa): "
	read ssh_key
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

# SSH Agent Configuration
echo "Configuring SSH agent..."
add_ssh_agent

echo "Finished environment setup procedures"

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect if the OS is Arch-based or Debian-based
if command_exists pacman; then
    PACKAGE_MANAGER=("pacman" "-S" "--noconfirm")
    INSTALL_CMD=("pacman" "-Syu" "--noconfirm")
    VENV_PACKAGE="python-virtualenv"
    JDK_PACKAGE="jdk-openjdk"
    POSTMAN_PACKAGE="postman-bin"
    VS_CODE_PACKAGE="visual-studio-code-bin"
    CHROME_PACKAGE="google-chrome"
    MATTERMOST_PACKAGE="mattermost-desktop"
    TEAMS_PACKAGE="teams"
    SPOTIFY_PACKAGE="spotify"
    INTELLIJ_PACKAGE="intellij-idea-community-edition"
    PYCHARM_PACKAGE="pycharm-community-edition"
    EMAIL_CLIENT_PACKAGE="kmail"
    ZOOM_PACKAGE="zoom"
    OBSIDIAN_PACKAGE="obsidian"
    DRACULA_KONSOLE_URL="https://raw.githubusercontent.com/dracula/konsole/master/Dracula.colorscheme"

    # Check for an AUR helper like yay or paru
    if command_exists yay; then
        AUR_INSTALLER=("yay" "-S" "--noconfirm")
    elif command_exists paru; then
        AUR_INSTALLER=("paru" "-S" "--noconfirm")
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
    PACKAGE_MANAGER=("apt" "install" "-y")
    INSTALL_CMD=("sudo" "apt" "update" "&&" "sudo" "apt" "install" "-y")
    VENV_PACKAGE="python3-venv"
    JDK_PACKAGE="default-jdk"
    POSTMAN_PACKAGE=""
    VS_CODE_PACKAGE="code"
    CHROME_PACKAGE="google-chrome-stable"
    MATTERMOST_PACKAGE="mattermost-desktop"
    TEAMS_PACKAGE="teams"
    SPOTIFY_PACKAGE="spotify-client"
    INTELLIJ_PACKAGE="intellij-idea-community"
    PYCHARM_PACKAGE="pycharm-community"
    EMAIL_CLIENT_PACKAGE="kmail"
    ZOOM_PACKAGE="zoom"
    OBSIDIAN_PACKAGE="obsidian"

    # Spotify repository setup for Debian-based systems
    if ! grep -q "spotify" /etc/apt/sources.list.d/* 2>/dev/null; then
        curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo tee /usr/share/keyrings/spotify-archive-keyring.gpg > /dev/null
        echo "deb [signed-by=/usr/share/keyrings/spotify-archive-keyring.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    fi

    # Add Google's repository for Chrome
    if ! grep -q "dl.google.com/linux/chrome/deb/" /etc/apt/sources.list.d/* 2>/dev/null; then
        wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo tee /usr/share/keyrings/google-linux-key.gpg > /dev/null
        echo "deb [signed-by=/usr/share/keyrings/google-linux-key.gpg] https://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    fi

    # Zoom repository setup for Debian-based systems
    if ! grep -q "zoom" /etc/apt/sources.list.d/* 2>/dev/null; then
        wget -qO- https://zoom.us/linux/download/pubkey | sudo tee /usr/share/keyrings/zoom-linux-key.gpg > /dev/null
        echo "deb [signed-by=/usr/share/keyrings/zoom-linux-key.gpg] https://zoom.us/linux/debian stable main" | sudo tee /etc/apt/sources.list.d/zoom.list
    fi

    sudo apt update
else
    echo "Unsupported package manager. Please use a Debian or Arch-based system."
    exit 1
fi

# Core utilities
CORE_UTILS=(ssh curl git vim python3 valgrind)

# Add base-devel for Arch-based systems if pacman is detected
if command_exists pacman; then
    CORE_UTILS+=(base-devel)
fi

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

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install missing tools with error handling
install_tools() {
    local tool_category="$1"
    shift
    local tools=("$@")
    local missing_tools=()

    # Check for missing tools
    for tool in "${tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_tools+=("$tool")
        else
            eval "INSTALLED_${tool_category}+=('$tool')"
        fi
    done

    if [ ${#missing_tools[@]} -eq 0 ]; then
        echo "All ${tool_category//_/ } are already installed."
        return
    fi

    # Prompt user for installation
    printf "Do you want to install missing ${tool_category//_/ }? (${missing_tools[*]}): [Y/n] "
    read answer
    answer=${answer:-Y}
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        echo "Installing missing ${tool_category//_/ }: ${missing_tools[*]}..."
        
        # Update repositories once if needed
        if [ -z "$INSTALL_CMD_RUN" ]; then
            $INSTALL_CMD || { echo "Failed to update repositories."; return 1; }
            INSTALL_CMD_RUN=true
        fi

        for tool in "${missing_tools[@]}"; do
            if [[ "$tool" == *"-bin" || "$tool" == "$CHROME_PACKAGE" || "$tool" == "teams" || "$tool" == "mattermost-desktop" || "$tool" == "spotify" || "$tool" == "$INTELLIJ_PACKAGE" || "$tool" == "$PYCHARM_PACKAGE" || "$tool" == "$EMAIL_CLIENT_PACKAGE" || "$tool" == "$ZOOM_PACKAGE" || "$tool" == "$OBSIDIAN_PACKAGE" ]] && [ -n "$AUR_INSTALLER" ]; then
                echo "Installing $tool from AUR..."
                if ! $AUR_INSTALLER "$tool"; then
                    echo "Failed to install $tool from AUR."
                fi
            elif [[ "$tool" == "google-chrome-stable" ]]; then
                echo "Installing Google Chrome..."
                if ! sudo apt install -y google-chrome-stable; then
                    echo "Failed to install Google Chrome."
                fi
            elif [[ "$tool" == "zoom" && "$PACKAGE_MANAGER" == "apt install -y" ]]; then
                echo "Installing Zoom..."
                if ! sudo apt install -y zoom; then
                    echo "Failed to install Zoom."
                fi
            elif [[ "$tool" == "obsidian" ]]; then
                echo "Installing Obsidian..."
                if [ "$PACKAGE_MANAGER" == "apt install -y" ]; then
                    local obsidian_url
                    obsidian_url=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep "browser_download_url.*amd64.deb" | cut -d '"' -f 4)
                    if [ -n "$obsidian_url" ]; then
                        wget "$obsidian_url" -O /tmp/obsidian.deb
                        if sudo dpkg -i /tmp/obsidian.deb && sudo apt -f install -y; then
                            echo "Successfully installed Obsidian."
                        else
                            echo "Failed to install Obsidian."
                        fi
                        rm /tmp/obsidian.deb
                    else
                        echo "Failed to fetch Obsidian download URL."
                    fi
                elif [ -n "$AUR_INSTALLER" ]; then
                    if ! $AUR_INSTALLER obsidian; then
                        echo "Failed to install Obsidian from AUR."
                    fi
                fi
            else
                echo "Installing $tool..."
                if ! sudo $PACKAGE_MANAGER "$tool"; then
                    echo "Failed to install $tool."
                fi
            fi
        done
    else
        echo "Skipping installation of missing ${tool_category//_/ }."
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
printf "Do you want to configure Git? [Y/n] "
read git_configure
git_configure=${git_configure:-Y}
if [[ "$git_configure" =~ ^[Yy]$ ]]; then
    echo "Configuring Git account..."
    printf "Enter your Git username: "
    read git_username
    printf "Enter your Git email: "
    read git_email	

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
printf "Do you want to install and configure Vim? [Y/n] "
read vim_install
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
    installed_var="INSTALLED_$category"
    # Indirect expansion compatible with both bash and zsh
    eval "installed_tools=(\"\${${installed_var}[@]}\")"
    if [ ${#installed_tools[@]} -ne 0 ]; then
        echo "${category//_/ }: ${installed_tools[*]}"
    fi
done

echo "Finished environment setup procedures"
exit 0
