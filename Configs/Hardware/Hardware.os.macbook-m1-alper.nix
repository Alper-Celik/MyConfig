{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  boot.initrd.availableKernelModules = [ "usb_storage" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.networkmanager.wifi.backend = "iwd";
  hardware.asahi.peripheralFirmwareDirectory = inputs.macbook-m1-alper-firmware;

  hardware.apple.touchBar = {
    enable = true;
    package = pkgs.tiny-dfr;
  };

  swapDevices = [
    {
      priority = 0;
      device = "/.swap-files/swap-file";
      size = 32 * 1024;
      encrypted = {
        enable = true;
        label = "cryptroot";
        blkDev = "/dev/disk/by-label/main-luks";
      };
    }
  ];

}
