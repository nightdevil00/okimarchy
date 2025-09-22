#!/bin/bash

# Okimarchy Niri Autostart Script
# Fixes timing issues with uwsm environment variables and spawn-at-startup

# Log file for debugging
LOG_FILE="$HOME/.cache/niri-autostart.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "$(date): Starting Okimarchy niri-autostart.sh"

# Wait for WAYLAND_DISPLAY to be available
timeout=30
while [ -z "$WAYLAND_DISPLAY" ] && [ $timeout -gt 0 ]; do
    sleep 0.5
    timeout=$((timeout - 1))
    # Try to get environment from systemd user manager
    eval "$(systemctl --user show-environment | grep '^WAYLAND_DISPLAY=')" 2>/dev/null
    echo "$(date): Waiting for WAYLAND_DISPLAY... timeout=$timeout, WAYLAND_DISPLAY=$WAYLAND_DISPLAY"
done

if [ -z "$WAYLAND_DISPLAY" ]; then
    echo "$(date): WAYLAND_DISPLAY not available after waiting" >&2
    exit 1
fi

# Import other necessary environment variables
eval "$(systemctl --user show-environment | grep '^DISPLAY=')" 2>/dev/null
eval "$(systemctl --user show-environment | grep '^XDG_SESSION_TYPE=')" 2>/dev/null  
eval "$(systemctl --user show-environment | grep '^XDG_CURRENT_DESKTOP=')" 2>/dev/null

echo "$(date): Environment ready:"
echo "  WAYLAND_DISPLAY=$WAYLAND_DISPLAY"
echo "  DISPLAY=$DISPLAY"
echo "  XDG_SESSION_TYPE=$XDG_SESSION_TYPE"
echo "  XDG_CURRENT_DESKTOP=$XDG_CURRENT_DESKTOP"

# Start essential UI applications for Okimarchy Niri
echo "$(date): Starting waybar..."
waybar &
WAYBAR_PID=$!

echo "$(date): Starting swaybg with Okimarchy background..."
swaybg -i ~/.config/omarchy/current/background -m fill &
SWAYBG_PID=$!

echo "$(date): Starting mako notifications..."
mako &
MAKO_PID=$!

echo "$(date): Starting swayosd-server..."
swayosd-server &
SWAYOSD_PID=$!

echo "$(date): Okimarchy Niri UI applications started successfully"
echo "  PIDs: waybar=$WAYBAR_PID swaybg=$SWAYBG_PID mako=$MAKO_PID swayosd=$SWAYOSD_PID"

# Wait for all background jobs
wait
