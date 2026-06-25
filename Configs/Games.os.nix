{
  pkgs,
  pkgs-stable,
  config,
  lib,
  system,
  ...
}:
let
  gamescope-env = {
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

in
{
  environment.systemPackages = lib.mkIf (system == "x86_64-linux") (
    with pkgs;
    [
      pkgs-stable.heroic
      wine-staging
      lutris
      pkgs-stable.bottles
      legendary-gl
      prismlauncher # minecraft

      protonup-qt
      steamtinkerlaunch
      gamescope
    ]
  );

  programs.steam = lib.mkIf (system == "x86_64-linux") {
    enable = true;
    package = pkgs.steam.override {
      extraLibraries =
        p: with p; [
          nss
        ];
    };
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    localNetworkGameTransfers.openFirewall = true;
  };

  # Steam needs this to find Proton-GE
  environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = lib.mkIf (
    config.nixpkgs.hostPlatform == "x86_64-linux"
  ) "\${HOME}/.steam/root/compatibilitytools.d";

  # jovian = {
  #   steam = {
  #     desktopSession = "plasma";
  #     enable = true;
  #   };
  # };
}
