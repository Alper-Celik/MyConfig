{ lib, pkgs, ... }:
{

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";

  programs.dconf.enable = true;

  environment.systemPackages =
    with pkgs;
    [ ]
    ++ (with kdePackages; [
      plasma-workspace
      knewstuff
      kcmutils
      systemsettings
      qttools

      # Artwork + themes
      breeze
      ocean-sound-theme
      qqc2-breeze-style
      qqc2-desktop-style

      # misc Plasma extras
      kdeplasma-addons
      pkgs.xdg-user-dirs # recommended upstream

      breeze.qt5
      plasma-integration.qt5
      kwayland-integration
      kio-extras-kf5
    ]);

  environment.sessionVariables.KPACKAGE_DEP_RESOLVERS_PATH = "${pkgs.kdePackages.frameworkintegration.out}/libexec/kf6/kpackagehandlers";
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;

  services.accounts-daemon.enable = true;
  systemd.services.accounts-daemon.serviceConfig.PrivateTmp = false;

  services.udisks2.enable = true;
  services.libinput.enable = true;
  services.geoclue2.enable = true;

  qt = {
    enable = true;
    platformTheme = "kde";
  };
}
