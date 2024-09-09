{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9ab63d85-e706-4f79-a99b-646c5ba92e05";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "compress=zstd"
      "noatime"
    ];
  };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/d1aaf43e-a688-4e1d-932d-10517434a5e0";

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/9ab63d85-e706-4f79-a99b-646c5ba92e05";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/9ab63d85-e706-4f79-a99b-646c5ba92e05";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/persistent" = {
    device = "/dev/disk/by-uuid/9ab63d85-e706-4f79-a99b-646c5ba92e05";
    fsType = "btrfs";
    neededForBoot = true;
    options = [
      "subvol=persistent"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3336-2C5A";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
}
