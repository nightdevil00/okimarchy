# Copy over Omarchy configs
mkdir -p ~/.config
cp -R ~/.local/share/omarchy/config/* ~/.config/

# Setup window manager specific configurations
if [[ -z "$OKIMARCHY_WM_SELECTION" ]]; then
    OKIMARCHY_WM_SELECTION="Hyprland (default)"
fi

# Determine boot default when both WMs are selected
# Priority: Hyprland is default when both are selected, Niri only when selected alone
boot_wm="hyprland"
if echo "$OKIMARCHY_WM_SELECTION" | grep -q "Niri" && ! echo "$OKIMARCHY_WM_SELECTION" | grep -q "Hyprland"; then
    boot_wm="niri"
fi

echo "Boot default window manager: $boot_wm"

# Generate Niri configuration if Niri is selected
if echo "$OKIMARCHY_WM_SELECTION" | grep -q "Niri"; then
    echo "Setting up Niri configuration..."
    
    # Generate initial Niri config using our built-in tool
    if command -v omarchy-niri-config-gen >/dev/null 2>&1; then
        omarchy-niri-config-gen generate
        echo "Niri configuration generated successfully"
    else
        echo "Warning: omarchy-niri-config-gen not found in PATH"
        echo "You can manually generate the config later by running: omarchy-niri-config-gen generate"
    fi
fi

# Update the auto-login service based on the determined boot default
if [ -f /etc/systemd/system/omarchy-seamless-login.service ]; then
    echo "Setting up auto-login service for $boot_wm..."
    
    case "$boot_wm" in
        "niri")
            sudo sed -i 's|^ExecStart=.*|ExecStart=/usr/local/bin/seamless-login uwsm start -- niri.desktop|' /etc/systemd/system/omarchy-seamless-login.service
            echo "Auto-login service configured for Niri with uwsm"
            ;;
        "hyprland")
            sudo sed -i 's|^ExecStart=.*|ExecStart=/usr/local/bin/seamless-login uwsm start -- hyprland.desktop|' /etc/systemd/system/omarchy-seamless-login.service
            echo "Auto-login service configured for Hyprland with uwsm"
            ;;
    esac
    
    sudo systemctl daemon-reload
    echo "Auto-login service updated"
fi

# Use default bashrc from Omarchy
cp ~/.local/share/omarchy/default/bashrc ~/.bashrc
