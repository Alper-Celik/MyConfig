{ pkgs, lib, ... }:
{

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # default wayland
  services.displayManager.defaultSession = "plasma";

  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
  services.desktopManager.plasma6 = {
    enable = true;
    # useQtScaling = true;
    # phononBackend = "vlc";
  };

  environment.systemPackages = with pkgs; [
    kdePackages.plasma-vault
    # libsForQt5.bismuth #plasma tiling
  ];

  programs.dconf.enable = true;
}
