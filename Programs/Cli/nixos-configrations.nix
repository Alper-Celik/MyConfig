{ inputs, lib, config, pkgs, specialArgs, ... }:
{

  environment.systemPackages = import ./program-list.nix { inherit pkgs; };
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

  programs.fish.enable = true;
  programs.fish.promptInit = ''
    any-nix-shell fish --info-right | source
  '';
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "qt";
  };

  virtualisation.libvirtd.enable = true;

  virtualisation.podman = {
    enable = true;

    dockerCompact = true;
    dockerSocket.enable = true;
  };

  programs.nix-ld.enable = true;
}
