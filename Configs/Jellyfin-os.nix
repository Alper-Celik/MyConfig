{ ... }:
{
  fileSystems."/var/lib/jellyfin/Videos" = {
    device = "/home/alper/Videos";
    options = [ "bind" ];
  };
  environment.persistence."/persistent".directories = [{
    directory = "/var/lib/jellyfin";
    user = "jellyfin";
    group = "jellyfin";
  }];
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
