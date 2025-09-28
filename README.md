# Okimarchy

**Okimarchy** is an *okimari* flavor of arch forked from Omarchy.
This transforms Omarchy from an *omakase* (chef's choice) to an *okimari* (pre-set menu) approach:
- **Omakase**: Trust the chef completely (original Omarchy with Hyprland only)
- **Okimari**: Choose from carefully curated options (Okimarchy with Hyprland or Niri)

## Key Features

- **Dual Window Manager Support**: Users can now choose between Hyprland and Niri during installation. Both WMs can be installed simultaneously.
- **Runtime Switching**: Switch between window managers after installation via the Omarchy Menu (*Omarchy Menu (Mod+Alt+Space) -> Setup -> Window Manager*) or `okimarchy-wm-switch` command
- **Consistent Theming**: Niri configurations for all existing themes (Catppuccin, Gruvbox, Nord, Tokyo Night, etc.)
- **Unified Keybindings**: Niri configured to match Hyprland's keybindings and behavior
- Niri is configured to look and feel similar to Hyprland and to follow the Omarchy philosophy.

**Configuration System:**
- Modular Niri configuration files (`bindings.kdl`, `layout.kdl`, `windows.kdl`, etc.) and a dynamic Niri configuration generator (`omarchy-niri-config-gen`)
- Theme-specific Niri configurations for all existing themes

## Installation

1. Download and install arch linux (https://archlinux.org/download/)
   *Recommended*: Boot from the Arch Linux ISO and run `archinstall`.
2. Install Omarchy by running the following command:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/cristian-fleischer/okimarchy/master/boot.sh | OMARCHY_REPO="cristian-fleischer/okimarchy" bash
   ```

---

# Omarchy

Turn a fresh Arch installation into a fully-configured, beautiful, and modern web development system based on Hyprland by running a single command. That's the one-line pitch for Omarchy (like it was for Omakub). No need to write bespoke configs for every essential tool just to get started or to be up on all the latest command-line tools. Omarchy is an opinionated take on what Linux can be at its best.

Read more at [omarchy.org](https://omarchy.org).

## License

Omarchy is released under the [MIT License](https://opensource.org/licenses/MIT).
