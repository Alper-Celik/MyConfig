{ pkgs, ... }:
{
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        vhostUserPackages = [ pkgs.virtiofsd ];
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    waydroid.enable = true;

    podman = {
      enable = true;

      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };

  users.users.alper.extraGroups = [
    "podman"
    "libvirtd"
  ];

}
