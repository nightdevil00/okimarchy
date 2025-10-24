#!/bin/bash
set -e

error_exit() {
  echo -e "\033[31mERROR: Migration failed! Manual intervention required.\033[0m" >&2
  echo -e "\033[31mDO NOT REBOOT - System may be in inconsistent state until the error is fixed.\033[0m" >&2
  exit 1
}

trap error_exit ERR

echo "Change display manager to SDDM"

omarchy-pkg-add sddm libsecret gnome-keyring || error_exit

sudo mkdir -p /etc/sddm.conf.d

# Ensure Niri (uwsm) session entry exists
sudo mkdir -p /usr/share/wayland-sessions
if [ ! -f /usr/share/wayland-sessions/niri-uwsm.desktop ]; then
  sudo tee /usr/share/wayland-sessions/niri-uwsm.desktop >/dev/null <<'DESKTOP'
[Desktop Entry]
Name=Niri (uwsm)
Comment=Start Niri via UWSM
Exec=uwsm start -- niri --session
Type=Application
DesktopNames=niri
DESKTOP
fi

# Choose session based on selected WM(s)
session="hyprland-uwsm"
if echo "${OKIMARCHY_WM_SELECTION:-}" | grep -q "Niri"; then
  session="niri-uwsm"
fi

cat <<EOF2 | sudo tee /etc/sddm.conf.d/autologin.conf
[Autologin]
User=$USER
Session=$session

[Theme]
Current=breeze
EOF2

sudo systemctl disable omarchy-seamless-login.service
sudo systemctl unmask plymouth-quit-wait.service
sudo systemctl enable getty@tty1.service
sudo systemctl enable sddm.service
sudo systemctl daemon-reload

if systemctl is-enabled omarchy-seamless-login.service >/dev/null 2>&1; then
  echo -e "\033[31mError: omarchy-seamless-login.service is still enabled\033[0m" >&2
  error_exit
fi

if systemctl is-masked plymouth-quit-wait.service >/dev/null 2>&1; then
  echo -e "\033[31mError: plymouth-quit-wait.service is still masked\033[0m" >&2
  error_exit
fi

if ! systemctl is-enabled getty@tty1.service >/dev/null 2>&1; then
  echo -e "\033[31mError: getty@tty1.service is not enabled\033[0m" >&2
  error_exit
fi

if ! systemctl is-enabled sddm.service >/dev/null 2>&1; then
  echo -e "\033[31mError: sddm.service is not enabled\033[0m" >&2
  error_exit
fi

sudo rm -f /usr/local/bin/seamless-login
sudo rm -f /etc/systemd/system/plymouth-quit.service.d/wait-for-graphical.conf
sudo rm -f /etc/systemd/system/omarchy-seamless-login.service
