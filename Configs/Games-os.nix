{ pkgs, ... }:
let
  gamescope-env = {
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

in
{
  environment.systemPackages = with pkgs; [
    heroic
    bottles
    legendary-gl
    prismlauncher # minecraft

    protonup-qt
    steamtinkerlaunch

  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession = {
      enable = true;
      env = gamescope-env;
      args = [ "--rt" ];
    };
  };
  programs.gamescope = {
    enable = true;
    env = gamescope-env;
    capSysNice = true;
    args = [ "--rt" ];
  };
}
