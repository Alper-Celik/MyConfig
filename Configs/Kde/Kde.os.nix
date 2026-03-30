{ pkgs, lib, ... }:
{

  programs.kde-pim = {
    enable = false;
    kontact = true;
    kmail = true;
    merkuro = true;
  };

  services.desktopManager.plasma6 = {
    enable = false;
    # useQtScaling = true;
    # phononBackend = "vlc";
  };

  environment.systemPackages = with pkgs; [
    # kdePackages.yakuake
    # kdePackages.plasma-vault
    # gocryptfs
    # kdePackages.kdepim-addons
    # libsForQt5.bismuth #plasma tiling
  ];
}
