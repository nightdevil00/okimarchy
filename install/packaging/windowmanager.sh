#!/bin/bash

# Install window manager specific packages based on selection
if [[ -z "$OKIMARCHY_WM_SELECTION" ]]; then
    echo "No window manager selection found, defaulting to Hyprland"
    OKIMARCHY_WM_SELECTION="Hyprland (default)"
fi

echo "Installing packages for selected window manager(s): $OKIMARCHY_WM_SELECTION"

# Install Hyprland packages if selected
if echo "$OKIMARCHY_WM_SELECTION" | grep -q "Hyprland"; then
    echo "Installing Hyprland packages..."
    mapfile -t hyprland_packages < <(grep -v '^#' "${OMARCHY_INSTALL:-$(pwd)/install}/omarchy-hyprland.packages" | grep -v '^$')
    if [ ${#hyprland_packages[@]} -gt 0 ]; then
        if ! sudo pacman -S --noconfirm --needed "${hyprland_packages[@]}"; then
            echo "ERROR: Failed to install Hyprland packages" >&2
            exit 1
        fi
        echo "Hyprland packages installed successfully"
    fi
fi

# Install Niri packages if selected
if echo "$OKIMARCHY_WM_SELECTION" | grep -q "Niri"; then
    echo "Installing Niri packages..."
    mapfile -t niri_packages < <(grep -v '^#' "${OMARCHY_INSTALL:-$(pwd)/install}/omarchy-niri.packages" | grep -v '^$')
    if [ ${#niri_packages[@]} -gt 0 ]; then
        if ! sudo pacman -S --noconfirm --needed "${niri_packages[@]}"; then
            echo "ERROR: Failed to install Niri packages" >&2
            exit 1
        fi
        echo "Niri packages installed successfully"
    fi
    
    echo "Niri configuration will be handled by built-in omarchy-niri-config-gen tool"
fi

echo "Window manager package installation completed."
