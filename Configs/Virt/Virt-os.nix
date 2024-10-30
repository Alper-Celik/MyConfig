{
  pkgs,
  system,
  inputs,
  ...
}:
{

  programs.appimage.binfmt = true;

  environment.persistence."/persistent".directories = [
    "/var/lib/waydroid/"
    "/var/lib/containers"

    # "/var/lib/libvirt/"

    # "/var/lib/libvirt/dnsmasq"
    # "/var/lib/libvirt/images"
    # "/var/lib/libvirt/qemu"
    # "/var/lib/libvirt/secrets"
    # "/var/lib/libvirt/storage"
    # "/var/lib/libvirt/swtpm"
  ];
  environment.systemPackages = [
    inputs.winapps.packages.${system}.winapps
    inputs.winapps.packages.${system}.winapps-launcher # optional
    pkgs.distrobox
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
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

    podman = {
      enable = true;
      # dockerCompat = true;
      dockerSocket.enable = true;

      autoPrune.enable = true;
    };
  };

  users.users.alper.extraGroups = [
    "docker"
    "libvirtd"
    "kvm"
  ];

}
