#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# We need gum already for the WM selection
sudo pacman -Syu --noconfirm --needed gum

echo -e "\nThis is \e[1mOkimarchy\e[0m an \e[3mokimari\e[0m flavor of arch derived from Omarchy."
echo -e "\e[1mOkimari\e[0m usually refers to \e[1mpre-set menus or fixed combinations\e[0m (like a lunch set, sushi set, or kaiseki-style course)."
echo -e "You're not leaving everything to the chef (\e[3momakase\e[0m). Instead, you're choosing from a \e[1mpredefined set\e[0m (\e[3mokimari\e[0m)."

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

# Define Omarchy locations
export OMARCHY_PATH="$HOME/.local/share/omarchy"
export OMARCHY_INSTALL="$OMARCHY_PATH/install"
export OMARCHY_INSTALL_LOG_FILE="/var/log/omarchy-install.log"
export PATH="$OMARCHY_PATH/bin:$PATH"

# Install
source "$OMARCHY_INSTALL/helpers/all.sh"
source "$OMARCHY_INSTALL/preflight/all.sh"
source "$OMARCHY_INSTALL/packaging/all.sh"
source "$OMARCHY_INSTALL/config/all.sh"
source "$OMARCHY_INSTALL/login/all.sh"
source "$OMARCHY_INSTALL/post-install/all.sh"
