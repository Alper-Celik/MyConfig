{ pkgs, lib, ... }:
{

  specialisation.Kde.configuration = {
    environment.etc."specialisation".text = "Kde";
    MyConfig.tags = [
      "Kde"
      "Desktop"
    ];

    # default wayland
    services.displayManager.defaultSession = "plasma";

    programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";

    programs.kde-pim = {
      enable = true;
      kontact = true;
      kmail = true;
      merkuro = true;
    };

    services.desktopManager.plasma6 = {
      enable = true;
      # useQtScaling = true;
      # phononBackend = "vlc";
    };

    environment.systemPackages = with pkgs; [
      haruna
      kdePackages.kasts
      ark
      qalculate-qt
      kate

      kdePackages.plasma-vault
      gocryptfs
      kdePackages.kdepim-addons
      # libsForQt5.bismuth #plasma tiling
    ];

    programs.dconf.enable = true;

    programs.kclock.enable = true;
    programs.kdeconnect.enable = true;
    programs.partition-manager.enable = true;
  };
}
