#!/bin/zsh

# Array of additional VS Code extensions to be installed
extensions=(
  "ms-python.python"  # Python language support
  "esbenp.prettier-vscode"  # Prettier for code formatting
  "dbaeumer.vscode-eslint"  # ESLint for JavaScript/TypeScript
  "eamodio.gitlens"  # GitLens - Git enhancements
  "streetsidesoftware.code-spell-checker"  # Spell checker
  "ms-vscode.cpptools"  # C/C++ tools
  "visualstudioexptteam.vscodeintellicode"  # AI-assisted IntelliSense
  "coenraads.bracket-pair-colorizer-2"  # Bracket colorization
  "shan.code-settings-sync"  # Sync settings across devices
  "ms-vsliveshare.vsliveshare"  # Real-time collaborative coding
  "ecmel.vscode-html-css"  # CSS support for HTML files
  "mohsen1.prettify-json"  # JSON formatter
  "christian-kohler.path-intellisense"  # Path auto-completion
  "njpwerner.autodocstring"  # Python docstring generator
  "golang.go"  # Go language support
  "rust-lang.rust-analyzer"  # Rust language support
  "ms-toolsai.jupyter"  # Jupyter notebooks
  "msjsdiag.debugger-for-chrome"  # Debugger for Chrome
  "hbenl.vscode-test-explorer"  # Test Explorer UI
  "sonarsource.sonarlint-vscode"  # Static code analysis
  "ms-azuretools.vscode-docker"  # Docker tools
  "yzhang.markdown-all-in-one"  # Markdown enhancements
  "msft-vscode.docs-markdown"  # Docs Markdown tools
  "wayou.vscode-todo-highlight"  # TODO highlighting
  "humao.rest-client"  # REST Client for API testing
  "github.copilot"  # GitHub Copilot - AI-powered code completion
  "alefragnani.project-manager"  # Project switching and management
  "sleistner.vscode-fileutils"  # File management utilities
  "dracula-theme.theme-dracula"  # Dracula theme
)

echo "Starting installation of Visual Studio Code extensions..."

# Loop through and prompt before installing each extension
for extension in $extensions; do
  echo "Do you want to install $extension? (y/n)"
  read -r answer
  if [[ $answer =~ ^[Yy]$ ]]; then
    echo "Installing $extension..."
    code --install-extension $extension
    if [[ $? -eq 0 ]]; then
      echo "$extension installed successfully."
    else
      echo "Failed to install $extension or it may already be installed."
    fi
  else
    echo "Skipping $extension."
  fi
done

echo "Installation process complete!"
