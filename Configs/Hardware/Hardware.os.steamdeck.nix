{
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.jovian-NixOS.nixosModules.default ];

  jovian = {
    devices.steamdeck.enable = true;
    steam = {
      enable = true;
      autoStart = true;
      user = "alper";
      desktopSession = "niri";
    };
  };

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
    "sdhci_pci"
  ];
  boot.kernelModules = [ "kvm-amd" ];
  nixpkgs.hostPlatform = "x86_64-linux";

  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true;
    bluetooth.enable = true;
  };

  swapDevices = [
    {
      priority = 0;
      device = "/.swap-files/swap-file";
      size = 32 * 1024; # 32 GiB
      encrypted = {
        enable = true;
        label = "cryptroot";
        blkDev = "/dev/disk/by-label/deck-luks";
      };
    }
  ];

  sops.age.keyFile = lib.mkForce "/persistent/keys.txt";

}
