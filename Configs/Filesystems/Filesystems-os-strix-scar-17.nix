{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  fileSystems."/" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "compress=zstd"
      "noatime"
    ];
  };

  # services.displayManager.autoLogin = {
  #   enable = true;
  #   user = "alper";
  # };
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-label/main-luks";

  fileSystems."/home" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/persistent" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    neededForBoot = true;
    options = [
      "subvol=persistent"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
}
