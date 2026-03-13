# Agent Instructions: NixOS Configuration

## Core Architecture

- **Structure**: This is a Flake-based NixOS/Home Manager configuration.
- **`Configs/`**: Modules are split into `.os.nix` (NixOS) and `.home.nix` (Home Manager) or with `<config>.<hostname>.nix` prefix like `./Configs/DisplayManager/DisplayManager.os.lenovo-ideapad-510.nix`
- **`my-lib/`**: Contains core helpers. Use `my-lib.maybeOutOfStore` for live editable path resolution.
- **`my-pkgs/`**: Local package definitions (e.g., `qml-material`) which is possible to use outside the config by including this flake on other projects.

## Live-Editing (Out-of-Store Symlinks)

frequently edited GUI/App configs use a symlinking pattern to allow editing files without a `nixos-rebuild`.

- **Convention**: `outOfStrore = x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);`
- **Impact**: When modifying Neovim (`Configs/Neovim/`), Hyprland (`Configs/Hyprland/`), or Quickshell (`Configs/Hyprland/quickshell/`), edit the source files directly. Do not wrap them in Nix strings unless explicitly asked.

## Neovim (LazyVim)

- **Location**: `Configs/Neovim/`
- **Plugins**: Add to `lua/plugins/*.lua`.
- **Dependencies**: System dependencies (LSPs, formatters) MUST be added to the `language-tools` list in `Neovim.home.nix`.

## Hyprland & UI

- **Hyprland**: Main config is `Configs/Hyprland/hyprland.conf`. Window rules are modularized in `hyprland-modules/`.
- **Quickshell**: UI components are QML files in `Configs/Hyprland/quickshell/`.
- **Scripts**: Shell scripts in `Configs/Hyprland/scripts/` are added to the user's `PATH` via Home Manager.
