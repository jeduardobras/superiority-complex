
# Environment Setup Script

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Linux-blue.svg)
![Shell](https://img.shields.io/badge/Shell-Bash-blue.svg)

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Supported Distributions](#supported-distributions)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Included Tools and Applications](#included-tools-and-applications)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)
- [VS Code Add-ons Script](#vs-code-add-ons-script)

## Introduction

This repository contains a comprehensive Bash script designed to automate the setup of a development environment on Linux systems. The script is tailored to work seamlessly with both Arch-based and Debian-based distributions. It installs essential development tools, configures system settings, and enhances the user experience for developers.

## Features

- **Automatic Detection**: Detects if the system is Arch-based or Debian-based and adapts the installation accordingly.
- **Essential Tools Installation**: Installs development tools such as `git`, `vim`, `curl`, `gcc`, and more.
- **IDE and Editor Support**: Installs popular IDEs including Visual Studio Code, IntelliJ IDEA, and PyCharm.
- **Vim Configuration**: Sets up `vim-plug` and configures Vim with a modern, customizable layout.
- **Terminal Enhancements**: Adds useful aliases, custom prompts, and applies the Dracula theme to the Konsole terminal.
- **API and Networking Tools**: Installs HTTPie and Postman (if an AUR helper is available).
- **Customization Options**: Users can select which tools to install and skip optional configurations.

## Supported Distributions

- **Arch-based distributions**: Manjaro, Arch Linux, etc.
- **Debian-based distributions**: Ubuntu, Linux Mint, Debian, etc.

## Prerequisites

- **Superuser Privileges**: Ensure you have `sudo` access to install packages.
- **AUR Helper**: For Arch-based systems, it's recommended to have `yay` or `paru` for AUR package installations.

## Installation

1. **Clone the Repository**:

    ```bash
    git clone https://github.com/yourusername/environment-setup-script.git
    cd environment-setup-script
    ```

2. **Run the Script**:

    ```bash
    chmod +x setup.sh
    ./setup.sh
    ```

## Usage

- The script will prompt for confirmation before installing missing tools and configuring optional components.
- Git configuration, Vim setup, and SSH agent configuration will be interactively set up during the script's execution.

## Configuration

The script configures the following:

- **Vim**: Sets up `vim-plug` and installs specified plugins.
- **Bash**: Adds aliases and sets a custom PS1 prompt in `.bashrc`.
- **SSH Agent**: Adds SSH key management to `.bashrc` if desired.

## Included Tools and Applications

### Core Utilities
- `ssh`, `curl`, `git`, `vim`, `python3`, `valgrind`

### Compilers
- `gcc`, `default-jdk` (Debian), `jdk-openjdk` (Arch)

### Development Tools
- `docker`, `virtualenv`, Visual Studio Code, IntelliJ IDEA, PyCharm

### Terminal Tools
- `tmux`, `htop`

### Search and Fuzzy Find Tools
- `ripgrep`, `fzf`, `screenfetch`

### Entertainment
- `spotify`

### Browsers and Conferencing Tools
- Google Chrome, Zoom

## Customization

You can customize the script by editing the list of tools and applications defined in the script's arrays:

```bash
CORE_UTILS=(ssh curl git vim python3 valgrind)
DEV_UTILS=(docker python3-venv code)
```
Comment out or remove any tools you don't want to install.

## Troubleshooting

- Ensure your system's package manager is up-to-date before running the script.
- If an AUR helper is not found, certain packages will be skipped. Install `yay` or `paru` to enable AUR support.

## VS Code Add-ons Script

### New Feature: VS Code Add-ons Installation Script

This repository also includes a Zsh script designed to help you manage and install essential Visual Studio Code add-ons. The script prompts the user for each extension installation, allowing you to selectively install what you need.

#### Installation and Usage

1. **Run the Script:**

   ```bash
   chmod +x vscode-addons.sh
   ./vscode-addons.sh
   ```

2. **Features of the Script**:
   - Prompts the user before installing each Visual Studio Code extension.
   - Installs popular extensions for language support, code formatting, Git enhancements, and more.
   - Customizable list of extensions based on your development needs.

#### Default Extensions Included:

- **Languages & Development Tools**:
  - `ms-python.python` (Python)
  - `ms-vscode.cpptools` (C/C++)
  - `golang.go` (Go)
  - `rust-lang.rust-analyzer` (Rust)
- **Code Formatting & Linting**:
  - `esbenp.prettier-vscode` (Prettier)
  - `dbaeumer.vscode-eslint` (ESLint)
- **Collaboration & Git Tools**:
  - `eamodio.gitlens` (GitLens)
  - `ms-vsliveshare.vsliveshare` (Live Share)
- **Productivity Enhancements**:
  - `visualstudioexptteam.vscodeintellicode` (IntelliCode)
  - `dracula-theme.theme-dracula` (Dracula Theme)
  - `github.copilot` (GitHub Copilot - AI-powered code completion)
  
... and more! You can edit the included list in the `vscode-addons.sh` file to customize your setup further.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request if you have suggestions or improvements.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
