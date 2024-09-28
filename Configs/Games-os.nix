{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    heroic
    lutris
    legendary-gl
    prismlauncher # minecraft

    wineWowPackages.stagingFull
    protonup-qt

  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  };
}
