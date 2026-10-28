{
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.jovian-NixOS.nixosModules.default ];

  # Jovian's SteamOS defaults turn on systemd-oomd; earlyoom is already running
  # from the same place. One killer, one policy: earlyoom picks the fattest
  # process (and nix-daemon carries OOMScoreAdjust=1000, so builds go first).
  systemd.oomd.enable = lib.mkForce false;

  jovian = {
    devices.steamdeck.enable = true;
    steam = {
      enable = true;
      autoStart = true;
      user = "alper";
      desktopSession = "niri";
    };
  };

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
    "sdhci_pci"
  ];
  boot.kernelModules = [ "kvm-amd" ];
  nixpkgs.hostPlatform = "x86_64-linux";

  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true;
    bluetooth.enable = true;
  };

  swapDevices = [
    {
      priority = 0;
      device = "/.swap-files/swap-file";
      size = 32 * 1024; # 32 GiB
      encrypted = {
        enable = true;
        label = "cryptroot";
        blkDev = "/dev/disk/by-label/deck-luks";
      };
    }
  ];

  # 14 GiB, shared with the GPU: a full-width rust or gcc build is the largest
  # single memory consumer on this machine. max-jobs = concurrent derivations,
  # cores = NIX_BUILD_CORES (what cargo -j and make -j see inside a build), so
  # 2 x 4 keeps peak memory bounded while still filling 8 threads.
  nix.settings = {
    max-jobs = 2;
    cores = 4;
  };

  # zram is the first swap tier here (priority 100, zstd). These keep the kernel
  # compressing anonymous pages into it instead of dropping page cache, and start
  # reclaiming before a burst becomes a direct-reclaim stall — which shows up as
  # frame drops and input lag, not as CPU load.
  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.page-cluster" = 0; # zram reads are cheap; readahead only wastes decompression
    "vm.watermark_scale_factor" = 125; # reclaim earlier, less direct reclaim
  };

  sops.age.keyFile = lib.mkForce "/persistent/keys.txt";

}
