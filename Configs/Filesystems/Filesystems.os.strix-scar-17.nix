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

  services.displayManager.autoLogin =
    if lib.elem "Desktop" config.MyConfig.tags then
      {
        enable = true;
        user = "alper";
      }
    else
      { };
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-label/main-luks";

  # thanks for https://github.com/nix-community/impermanence?tab=readme-ov-file#btrfs-subvolumes for snapshot logic
  # and https://discourse.nixos.org/t/impermanence-vs-systemd-initrd-w-tpm-unlocking/25167/3?u=alper-celik for systemd based solution
  boot.initrd.systemd.services.rollback = {
    description = "Rollback BTRFS root subvolume to a pristine state and keep old roots for 30 days";
    wantedBy = [
      "initrd.target"
    ];
    after = [
      # LUKS/TPM process
      "systemd-cryptsetup@cryptroot.service"
    ];
    before = [
      "sysroot.mount"
    ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir /.btrfs-root
      mount /dev/mapper/cryptroot /.btrfs-root
      if [[ -e /.btrfs-root/root ]]; then
          mkdir -p /.btrfs-root/old_roots
          timestamp=$(date --date="@$(stat -c %Y /.btrfs-root/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /.btrfs-root/root "/.btrfs-root/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/.btrfs-root/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /.btrfs-root/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /.btrfs-root/root
      umount /.btrfs-root
    '';
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
      "subvol=home"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/.swap-files" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [
      "subvol=.swap-files"
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
