{ ... }:
{
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd.enable = true;
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
