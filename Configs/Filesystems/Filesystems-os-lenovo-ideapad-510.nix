{ ... }:
{

  boot.supportedFilesystems = [ "ntfs3" ];
  # fileSystems."/" =
  #   {
  #     device = "/dev/disk/by-label/btrfs-hdd";
  #     fsType = "btrfs";
  #     options = [ "subvol=root" "compress=zstd" "noatime" ];
  #   };
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "defaults"
      "size=8G"
      "mode=755"
      "noatime"
    ];
  };

  fileSystems."/persistent" = {
    device = "/dev/disk/by-label/btrfs-hdd";
    fsType = "btrfs";
    neededForBoot = true;
    options = [
      "subvol=persistent"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/btrfs-hdd";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/home/alper/Archive" = {
    device = "/dev/disk/by-label/btrfs-hdd";
    fsType = "btrfs";
    options = [
      "subvol=/home/alper/Archive"
      "compress=zstd:7"
      "noatime"
    ];
  };
  fileSystems."/home/alper/Projects" = {
    device = "/dev/disk/by-label/btrfs-ssd";
    fsType = "btrfs";
    options = [
      "subvol=alper-Projects"
      "compress=zstd"
      "noatime"
    ];

  };
  fileSystems."/home/alper/.cache" = {
    device = "/dev/disk/by-label/btrfs-ssd";
    fsType = "btrfs";
    options = [
      "subvol=alper-cache"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/home/alper/Games" = {
    device = "/dev/disk/by-label/btrfs-ssd";
    fsType = "btrfs";
    options = [
      "subvol=Games"
      "compress=none"
      "noatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/btrfs-ssd";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
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
}
