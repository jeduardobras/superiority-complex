#!/bin/bash

# Vim 

## Create the vim configuration file
mkdir -p $HOME/.config/vim

echo "created vim configuration directory"

## Copies my vim config into the appropriate directory
cp .config/vim/jbras.vim $HOME/.config/vim

echo "created vim configuration file"

## Define the path to the Vim configuration file
VIM_CONFIG="$HOME/.config/vim/jbras.vim"

## Create the .vimrc file in the home directory
echo "set runtimepath+=~/.config/vim" > "$HOME/.vimrc"
echo "source $VIM_CONFIG" >> "$HOME/.vimrc"

echo ".vimrc created and configured to point to $VIM_CONFIG"



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
