# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)


{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, specialArgs, ... }: {
  imports = [
    ../DotFiles/dotfiles.nix

    ../Configs/configs.nix
    inputs.nix-index-database.hmModules.nix-index

    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];




  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = specialArgs.stateVersion;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # xdg.mimeApps.enable = true;

  programs.nix-index = {
    enableFishIntegration = false; #broken on fish shell for some reason
  };
}
