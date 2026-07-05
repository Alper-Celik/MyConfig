{
  pkgs,
  system,
  inputs,
  config,
  lib,
  ...
}:
{

  programs.appimage.binfmt = true;
  services.envfs.enable = true;

  environment.persistence."/persistent".directories = [
    "/var/lib/waydroid/"
    "/var/lib/containers"
    "/var/lib/docker/"

    # "/var/lib/libvirt/"

    "/var/lib/libvirt/dnsmasq"
    "/var/lib/libvirt/images"
    "/var/lib/libvirt/qemu"

    "/var/lib/libvirt/secrets"
    "/var/lib/libvirt/storage"

    "/var/lib/libvirt/swtpm"
  ];
  environment.systemPackages = [
    pkgs.distrobox
    pkgs.freerdp
    pkgs.vagrant
    pkgs.act
    pkgs.docker-compose
  ];
  users.extraGroups.vboxusers.members = [ "alper" ];

  # hack till https://github.com/NixOS/nixpkgs/pull/500039 is merged
  nixpkgs.overlays = lib.mkIf (system == "aarch64-linux") [
    (_: final: {
      qemu = final.qemu.overrideAttrs (oldAttrs: {
        configureFlags = oldAttrs.configureFlags ++ [ "--disable-pie" ];
      });
    })
  ];

  boot.binfmt.preferStaticEmulators = true;
  boot.binfmt.emulatedSystems =
    if system == "x86_64-linux" then
      [ "aarch64-linux" ]
    else if system == "aarch64-linux" then
      [ "x86_64-linux" ]
    else
      [ ];

  boot.kernelModules = [ "kvm-amd" ];
  programs.virt-manager.enable = true;
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        vhostUserPackages = [ pkgs.virtiofsd ];
      };
    };
    waydroid.enable = true;

    # docker = {
    #   package = pkgs.docker_29;
    #   enable = true;
    #
    #   storageDriver = "overlay2";
    #   autoPrune.enable = true;
    #   enableOnBoot = false;
    # };
    podman = {
      dockerCompat = true;
      dockerSocket.enable = true;
      enable = true;
      autoPrune.enable = true;
    };
  };

  users.users.alper.extraGroups = [
    "docker"
    "libvirtd"
    "kvm"
  ];

}
