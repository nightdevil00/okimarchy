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
    
    # Install niri-companion (required for Niri configuration)
    echo "Installing niri-companion..."
    
    # Try pipx first (better for externally managed environments)
    if command -v pipx >/dev/null 2>&1 || sudo pacman -S --noconfirm --needed python-pipx; then
        if pipx install niri-companion; then
            echo "niri-companion installed successfully via pipx"
            # Ensure pipx PATH is set up properly
            pipx ensurepath
            echo "PATH updated for pipx applications"
        else
            echo "ERROR: Failed to install niri-companion via pipx" >&2
            exit 1
        fi
    else
        # Fallback to pip with virtual environment
        echo "pipx not available, using pip with virtual environment..."
        if sudo pacman -S --noconfirm --needed python-pip python-virtualenv; then
            # Create virtual environment for niri-companion
            venv_dir="$HOME/.local/share/niri-companion-venv"
            if python -m venv "$venv_dir" && source "$venv_dir/bin/activate" && pip install niri-companion; then
                # Create a wrapper script
                wrapper_script="$HOME/.local/bin/niri-genconfig"
                mkdir -p "$HOME/.local/bin"
                cat > "$wrapper_script" << 'EOF'
#!/bin/bash
source "$HOME/.local/share/niri-companion-venv/bin/activate"
exec niri-genconfig "$@"
EOF
                chmod +x "$wrapper_script"
                # Ensure ~/.local/bin is in PATH
                if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
                    export PATH="$HOME/.local/bin:$PATH"
                    echo "Added ~/.local/bin to PATH for niri-companion"
                fi
                echo "niri-companion installed successfully in virtual environment"
            else
                echo "ERROR: Failed to install niri-companion in virtual environment" >&2
                exit 1
            fi
        else
            echo "ERROR: Failed to install required Python packages" >&2
            exit 1
        fi
    fi
fi

echo "Window manager package installation completed."
