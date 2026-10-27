{ ... }:
{
  boot.initrd = {
    luks.devices."cryptroot" = {
      device = "/dev/disk/by-label/deck-luks";
      allowDiscards = true;
      # YubiKey first, fall back to the unl0kr passphrase prompt.
      crypttabExtraOpts = [
        "fido2-device=auto"
        "token-timeout=20"
      ];
    };

    unl0kr = {
      enable = true;
      settings = {
        general = {
          animations = true;
          backend = "drm";
        };
        keyboard.layout = "trq";
        textarea.obscured = true;
      };
    };
  };

  fileSystems."/" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [
      "subvol=@root"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/.btrfs-root" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/.swap-files" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [
      "subvol=@swap-files"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/persistent" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    neededForBoot = true;
    options = [
      "subvol=@persistent"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/DECKBOOT";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
}
