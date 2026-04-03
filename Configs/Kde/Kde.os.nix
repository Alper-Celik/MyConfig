{ pkgs, lib, ... }:
{

  programs.kde-pim = {
    enable = true;
    kontact = true;
    kmail = true;
    merkuro = true;
  };

  services.desktopManager.plasma6 = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    kdePackages.plasma-vault
    gocryptfs
    kdePackages.kdepim-addons
  ];
}
