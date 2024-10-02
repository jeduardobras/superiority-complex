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

