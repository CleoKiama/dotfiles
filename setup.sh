#!/bin/bash

# Define the dotfiles directory
DOTFILES=$HOME/dotfiles

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"

    # Check if the symlink already exists and points to the correct file
    if [ -L "$target" ] && [ "$(readlink "$target")" == "$source" ]; then
        echo "Symlink already exists for $target -> $(readlink "$target")"
    else
        # Ensure the parent directory exists
        mkdir -p "$(dirname "$target")"

        echo "Creating symlink: $target -> $source"
        ln -sf "$source" "$target"
    fi
}

# List of directories/files to symlink
configs=(
    ".config/nvim"
    ".config/kitty"
    ".config/alacritty.toml"
    ".bashrc"
    ".tmux.conf"
    ".config/fontconfig"
    ".config/emacs"
    ".config/yazi"
)

# Create symlinks
for config in "${configs[@]}"; do
    create_symlink "$DOTFILES/$config" "$HOME/$config"
done

# Verify symlinks
echo -e "\nVerifying symlinks:"
for config in "${configs[@]}"; do
    echo "$config:"
    ls -la "$HOME/$config"
done
