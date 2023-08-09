{ ... }:
{
  environment.persistence."/persistent" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/AccountsService"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/backlight"

      "/etc/NetworkManager/system-connections"
    ];

    files = [
      "/etc/machine-id"
    ];
  };
  environment.etc = {
    # override user module 
    "passwd".source = "/persistent/etc/passwd";
    "group".source = "/persistent/etc/group";
    "shadow".source = "/persistent/etc/shadow";
  };
}
