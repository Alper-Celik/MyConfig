{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    (modulesPath + "/installer/scan/not-detected.nix")
    # inputs.nixos-hardware.nixosModules.asus-rog-strix-g733qs
    common-cpu-amd-pstate
    common-gpu-nvidia
    common-pc-laptop
    common-pc-laptop-ssd
    asus-battery
  ];
  hardware.asus.battery.chargeUpto = 85;
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=alc294-lenovo-mic
  '';

  environment.systemPackages = [ pkgs.supergfxctl-plasmoid ];
  services.supergfxd = {
    enable = true;
    settings = {
      gfx_vfio_enable = true;
    };
  };
  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  environment.persistence."/persistent".directories = [ "/etc/asusd" ];
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };

  sops.age.keyFile = lib.mkForce "/persistent/keys.txt";

  boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  boot.plymouth.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_6_12;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  systemd.oomd.enable = false; # dont kill running programms pleaaaaaaase !!

  nixpkgs.config.cudaSupport = true;
  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    dynamicBoost.enable = true;
    open = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };

    prime = {
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:8:0:0";
    };
  };

  zramSwap = {
    enable = true;
    priority = 100;
  };
  swapDevices = [
    {
      priority = 0;
      device = "/.swap-files/swap-file";
      size = 71680; # 70 GiB
      encrypted = {
        enable = true;
        label = "cryptroot";
        blkDev = "/dev/disk/by-label/main-luks";
      };
    }
  ];

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
  services.fwupd.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
}
