{ pkgs, pkgs-stable, ... }:
let
  gamescope-env = {
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

in
{
  environment.systemPackages = with pkgs; [
    pkgs-stable.heroic
    wine-staging
    lutris
    pkgs-stable.bottles
    legendary-gl
    prismlauncher # minecraft

    protonup-qt
    steamtinkerlaunch

  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    localNetworkGameTransfers.openFirewall = true;
  };

  # Steam needs this to find Proton-GE
  environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";

  # jovian = {
  #   steam = {
  #     desktopSession = "plasma";
  #     enable = true;
  #   };
  # };
}
