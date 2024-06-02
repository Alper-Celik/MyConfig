{ pkgs, ... }:
{
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.plymouth.enable = true;
  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" ];

  boot.initrd.systemd.enable = true;
  boot.resumeDevice = "/dev/disk/by-label/swap-nixos";



}
