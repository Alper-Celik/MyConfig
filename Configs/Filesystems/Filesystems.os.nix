{ ... }:
{
  # thanks for https://github.com/nix-community/impermanence?tab=readme-ov-file#btrfs-subvolumes for snapshot logic
  # and https://discourse.nixos.org/t/impermanence-vs-systemd-initrd-w-tpm-unlocking/25167/3?u=alper-celik for systemd based solution
  boot.initrd.systemd.services.rollback = {
    description = "Rollback BTRFS root subvolume to a pristine state and keep old roots for 30 days";
    wantedBy = [ "initrd.target" ];
    after = [
      # LUKS/TPM process
      "systemd-cryptsetup@cryptroot.service"
    ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir /.btrfs-root
      mount /dev/mapper/cryptroot /.btrfs-root
      if [[ -e /.btrfs-root/@root ]]; then
          mkdir -p /.btrfs-root/old_roots
          timestamp=$(date --date="@$(stat -c %Y /.btrfs-root/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /.btrfs-root/@root "/.btrfs-root/old_roots/$timestamp"
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

      btrfs subvolume create /.btrfs-root/@root
      umount /.btrfs-root
    '';
  };
}
