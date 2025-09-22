#!/bin/bash

# Set install mode to online since boot.sh is used for curl installations
export OMARCHY_ONLINE_INSTALL=true

ansi_art='                 ▄▄▄
 ▄█████▄    ▄███████████▄    ▄███████   ▄███████   ▄███████   ▄█   █▄    ▄█   █▄
███   ███  ███   ███   ███  ███   ███  ███   ███  ███   ███  ███   ███  ███   ███
███   ███  ███   ███   ███  ███   ███  ███   ███  ███   █▀   ███   ███  ███   ███
███   ███  ███   ███   ███ ▄███▄▄▄███ ▄███▄▄▄██▀  ███       ▄███▄▄▄███▄ ███▄▄▄███
███   ███  ███   ███   ███ ▀███▀▀▀███ ▀███▀▀▀▀    ███      ▀▀███▀▀▀███  ▀▀▀▀▀▀███
███   ███  ███   ███   ███  ███   ███ ██████████  ███   █▄   ███   ███  ▄██   ███
███   ███  ███   ███   ███  ███   ███  ███   ███  ███   ███  ███   ███  ███   ███
 ▀█████▀    ▀█   ███   █▀   ███   █▀   ███   ███  ███████▀   ███   █▀    ▀█████▀
                                       ███   █▀                                  '

clear
echo -e "\n$ansi_art\n"

sudo pacman -Syu --noconfirm --needed git gum

# Use custom repo if specified, otherwise default to basecamp/omarchy
# OMARCHY_REPO="${OMARCHY_REPO:-basecamp/omarchy}"

# echo -e "\nCloning Omarchy from: https://github.com/${OMARCHY_REPO}.git"
# Remove existing omarchy symlink/directory safely
if [ -L ~/.local/share/omarchy ]; then
    # If it's a symlink, remove the symlink itself (not its target)
    rm ~/.local/share/omarchy
elif [ -d ~/.local/share/omarchy ]; then
    # If it's a real directory, remove it
    rm -rf ~/.local/share/omarchy
fi
# git clone "https://github.com/${OMARCHY_REPO}.git" ~/.local/share/omarchy >/dev/null

# Use custom branch if instructed, otherwise default to master
# OMARCHY_REF="${OMARCHY_REF:-master}"
# if [[ $OMARCHY_REF != "master" ]]; then
#   echo -e "\e[32mUsing branch: $OMARCHY_REF\e[0m"
#   cd ~/.local/share/omarchy
#   git fetch origin "${OMARCHY_REF}" && git checkout "${OMARCHY_REF}"
#   cd -
# fi

# DEV

mkdir -p ~/.local/share
# Get absolute path of the script's directory
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
# Create symlink
ln -sfn "$SCRIPT_DIR" "$HOME/.local/share/omarchy"

# /DEV

# Window Manager Selection
echo -e "\n🖥️ Window Manager Selection"
echo "Choose your window manager(s) (Hyprland is selected by default):"

# Use gum to select window manager(s) with Hyprland pre-selected
selected_wm=$(gum choose --no-limit --selected="Hyprland (default)" "Hyprland (default)" "Niri (scrollable tiling)")

if [ -z "$selected_wm" ]; then
    echo -e "\e[33mNo selection made, defaulting to Hyprland\e[0m"
    selected_wm="Hyprland (default)"
fi

echo -e "\nSelected window manager(s):"
echo "$selected_wm" | while read -r wm; do
    echo "  ✓ $wm"
done

# Export for install scripts
export OKIMARCHY_WM_SELECTION="$selected_wm"

echo -e "\nInstallation starting..."
source ~/.local/share/omarchy/install.sh
