# Debian 12 Setup Script

This repository contains a script to automate the setup of a development environment on a Debian 12 (Bookworm) system. The script installs essential tools and configures various applications to streamline the development process.

## Features

- **Core Utilities**: Installs essential tools like `ssh`, `curl`, `git`, `vim`, and more.
- **Compilers**: Installs `gcc` and the latest JDK for development.
- **Development Tools**: Sets up `docker` and `python3-venv` for containerization and Python development.
- **API Tools**: Installs `Postman` and `HTTPie` for API testing.
- **Build Tools**: Installs `CMake` and `Make` for building projects.
- **Terminal Tools**: Sets up `tmux` and `htop` for terminal management and process monitoring.
- **Search and Fuzzy Find Tools**: Installs `ripgrep`, `fzf`, and `screenfetch` for efficient searching and system information display.
- **Git Configuration**: Prompts for Git username and email for version control setup.
- **Vim Configuration**: Downloads and sets up a customized Vim configuration with the Dracula color scheme.

## Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/your-repo.git
   cd your-repo

2. Make script executable
   chmod +x run.sh

3. Run the script
   ./run.sh

4. Follow the prompts to configure the git environment

# License

This project is licensed under the MIT License - see the LICENSE file for details.
