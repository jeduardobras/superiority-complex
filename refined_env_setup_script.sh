
#!/bin/bash

# Function to detect default shell and set configuration file
set_config_file() {
    DEFAULT_SHELL=$(basename "$SHELL")
    if [[ "$DEFAULT_SHELL" == "zsh" ]]; then
        CONFIG_FILE="$HOME/.zshrc"
    else
        CONFIG_FILE="$HOME/.bashrc"
    fi
}

# Detect and set config file
set_config_file

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

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

# Add custom PS1 prompt to shell if using bash
if [[ "$DEFAULT_SHELL" != "zsh" ]]; then
    if ! grep -q "export PS1=" "$CONFIG_FILE"; then
        echo 'export PS1="\[\e[1;32m\]\u@\h \[\e[1;34m\]\w\[\e[0m\] $ "' | tee -a "$CONFIG_FILE" > /dev/null
        echo "Custom PS1 prompt added to $CONFIG_FILE."
    else
        echo "PS1 prompt already customized in $CONFIG_FILE."
    fi
fi

# SSH Agent Configuration
echo "Configuring SSH agent..."
add_ssh_agent

echo "Finished environment setup procedures"
