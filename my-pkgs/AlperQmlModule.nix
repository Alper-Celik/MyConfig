{ inputs, pkgs, ... }:
pkgs.qt6.callPackage (import ../Configs/Hyprland/quickshell/cpp_module/package.nix) {
  inherit inputs;
}
