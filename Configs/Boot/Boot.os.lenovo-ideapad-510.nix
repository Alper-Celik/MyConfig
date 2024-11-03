{ pkgs, ... }:
{
  boot.loader = {
    # systemd-boot = {
    #   memtest86.enable = true;
    #   enable = true;
    # };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
    timeout = 3;
    efi.canTouchEfiVariables = true;
  };

  boot.plymouth.enable = true;
  # boot.consoleLogLevel = 0;
  # boot.kernelParams = [ "quiet" ];

  boot.initrd.systemd.enable = true;
  boot.resumeDevice = "/dev/disk/by-label/swap-nixos";

}
