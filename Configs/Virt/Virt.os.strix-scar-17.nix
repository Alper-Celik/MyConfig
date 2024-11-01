{ pkgs, ... }:
let
  qemu-d = ./strix-scar-17-qemu.d;
in
{
  systemd.services.libvirtd = {
    path =
      let
        env = pkgs.buildEnv {
          name = "qemu-hook-env";
          paths = with pkgs; [
            bash
            libvirt
            kmod
            systemd
            findutils
            supergfxctl
            libnotify
          ];
        };
      in
      [ env ];
  };
  virtualisation.libvirtd.hooks.qemu = {
    "qemu" = "${qemu-d}/qemu";
    "win11" = "${qemu-d}/win11";
  };
}
