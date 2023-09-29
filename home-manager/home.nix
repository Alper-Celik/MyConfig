{ inputs, lib, config, pkgs, specialArgs, ... }: {
  imports = [
    ../DotFiles/dotfiles.nix

    ../Configs/configs-home.nix
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

  programs.nix-index = {
    enable = true;
    enableFishIntegration = false; #broken on fish shell for some reason
  };
}
