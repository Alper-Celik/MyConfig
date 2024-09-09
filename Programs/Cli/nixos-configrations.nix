{
  inputs,
  lib,
  config,
  pkgs,
  my-pkgs,
  specialArgs,
  ...
}:
{

  environment.systemPackages =
    (import ./program-list.nix {
      inherit pkgs my-pkgs;
      kdePackages = pkgs.kdePackages;
    })
    ++ [
      config.boot.kernelPackages.perf

    ];
  environment.sessionVariables = {
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME = "\${HOME}/.local/bin";
    XDG_DATA_HOME = "\${HOME}/.local/share";
    # note: this doesn't replace PATH, it just adds this to it
    PATH = [
      "\${XDG_BIN_HOME}"
    ];
  };
  documentation.dev.enable = true;

  programs.gnupg.agent = {
    enable = true;
    # pinentryFlavor = "qt";
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.waydroid.enable = true;

  virtualisation.podman = {
    enable = true;
    enableNvidia = config.hardware.nvidia-container-toolkit.enable;

    dockerCompat = true;
    dockerSocket.enable = true;
  };

  programs.nix-ld.enable = true;
  programs.firejail = {
    enable = true;
  };
  security.sudo.extraConfig = "Defaults pwfeedback";
}
