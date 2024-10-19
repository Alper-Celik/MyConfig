{
  pkgs,
  system,
  inputs,
  ...
}:
{

  programs.appimage.binfmt = true;

  environment.systemPackages = [
    inputs.winapps.packages.${system}.winapps
    inputs.winapps.packages.${system}.winapps-launcher # optional
    pkgs.distrobox
  ];

  programs.virt-manager.enable = true;
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        vhostUserPackages = [ pkgs.virtiofsd ];
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    waydroid.enable = true;

    oci-containers.backend = "docker";
    docker = {
      enable = true;
    };
  };

  users.users.alper.extraGroups = [
    "docker"
    "libvirtd"
    "kvm"
  ];

}
