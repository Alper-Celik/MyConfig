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

  boot.initrd.systemd.enable = true;
  boot.resumeDevice = "/dev/disk/by-label/swap-nixos";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # fileSystems."/" =
  #   {
  #     device = "/dev/disk/by-label/btrfs-hdd";
  #     fsType = "btrfs";
  #     options = [ "subvol=root" "compress=zstd" "noatime" ];
  #   };
  fileSystems."/" =
    {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=8G" "mode=755" "noatime" ];
    };


  fileSystems."/persistent" =
    {
      device = "/dev/disk/by-label/btrfs-hdd";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=persistent" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-label/btrfs-hdd";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };

  fileSystems."/home/alper/Archive" =
    {
      device = "/dev/disk/by-label/btrfs-hdd";
      fsType = "btrfs";
      options = [ "subvol=/home/alper/Archive" "compress=zstd:7" "noatime" ];
    };
  fileSystems."/home/alper/Projects" =
    {
      device = "/dev/disk/by-label/btrfs-ssd";
      fsType = "btrfs";
      options = [ "subvol=alper-Projects" "compress=zstd" "noatime" ];

    };
  fileSystems."/home/alper/.cache" =
    {
      device = "/dev/disk/by-label/btrfs-ssd";
      fsType = "btrfs";
      options = [ "subvol=alper-cache" "compress=zstd" "noatime" ];
    };

  fileSystems."/home/alper/Games" =
    {
      device = "/dev/disk/by-label/btrfs-ssd";
      fsType = "btrfs";
      options = [ "subvol=Games" "compress=none" "noatime" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-label/btrfs-ssd";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/BOOT-NIXOS";
      fsType = "vfat";
    };

  # services.beesd.filesystems =
  #   {
  #     brfs-ssd = {
  #       spec = "/nix";
  #       hashTableSizeMB = 16 * 12;
  #       extraOptions = [ "--loadavg-target" "3" ];
  #     };
  #   };

  swapDevices = [{
    device = "/dev/disk/by-label/swap-nixos";
  }];

  nixpkgs.hostPlatform = "x86_64-linux";

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = "ondemand";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
