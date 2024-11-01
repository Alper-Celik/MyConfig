{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{

  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-hdd
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
  ];
  powerManagement.cpuFreqGovernor = "ondemand";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "rtsx_usb_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  hardware.nvidia.powerManagement.enable = true;

  boot.blacklistedKernelModules = [ "nouveau" ];
  hardware.nvidia.open = false; # my gpu is too old for open source kernell driver
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia.prime = {
    #   # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";
    #   # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:3:0:0";
  };

  hardware.enableAllFirmware = true;

  # boot.kernelPackages = pkgs.linuxPackages_zen;
  zramSwap.enable = true;

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap-nixos";
    }
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  systemd.oomd.enable = false; # dont kill running programms pleaaaaaaase !!

  hardware.bluetooth.enable = true;

}
