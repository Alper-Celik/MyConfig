# hardware specific thinks for ideapad
{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, specialArgs, ... }:

{
  imports =
    [
      ./display-gdm-monitors.xml.nix
      ./nvidia.nix
      inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia
      inputs.nixos-hardware.nixosModules.common-gpu-intel
      # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
      inputs.nixos-hardware.nixosModules.common-pc-laptop

    ];

  # boot.initrd.systemd.enable = true; ##### hibernate is broken on systemd-boot 

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/90ef9884-2bbc-4d6d-af4b-61e80fa4f6ef";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/90ef9884-2bbc-4d6d-af4b-61e80fa4f6ef";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/90ef9884-2bbc-4d6d-af4b-61e80fa4f6ef";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/0556-F3C6";
      fsType = "vfat";
    };
  #fileSystems."/mnt/winssd" =
  # {
  #  device = "/dev/disk/by-partuuid/50fd3a5a-97ce-4da6-a349-536dd02946b3";
  # fsType = "ntfs3";
  #options = [ "noatime" ];
  # };


  swapDevices =
    [{ device = "/dev/disk/by-uuid/6a154e7e-079e-428e-af9b-0684592de93f"; }];

  nixpkgs.hostPlatform = "x86_64-linux";

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
