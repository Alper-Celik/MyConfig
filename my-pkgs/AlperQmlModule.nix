{ inputs, pkgs, ... }:
pkgs.qt6.callPackage (import ../Configs/Quickshell/cpp_module/package.nix) {
  inherit inputs;
}
