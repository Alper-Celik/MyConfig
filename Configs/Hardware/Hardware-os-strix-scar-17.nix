{ inputs, config, lib, pkgs, modulesPath, ... }:
{
  imports =
    with inputs.nixos-hardware.nixosModules; [
      (modulesPath + "/installer/scan/not-detected.nix")
      # inputs.nixos-hardware.nixosModules.asus-rog-strix-g733qs
      common-cpu-amd-pstate
      common-gpu-nvidia
      common-pc-laptop
      common-pc-laptop-ssd
      asus-battery
    ];
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=alc294-lenovo-mic
  '';

  environment.systemPackages = [
    pkgs.supergfxctl-plasmoid
  ];
  services.supergfxd.enable = true;
  systemd.services.supergfxd.path = [ pkgs.pciutils ];
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };


  boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;


  boot.plymouth.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  systemd.oomd.enable = false; #dont kill running programms pleaaaaaaase !!


  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia = {
    powerManagement = {
      enable = true;
      finegrained = true;
    };

    prime = {
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:1";
    };
  };

  zramSwap.enable = true;
  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;


  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableAllFirmware = true;

}
