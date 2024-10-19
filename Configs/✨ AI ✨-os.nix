{ config, ... }:
{
  services.ollama = {
    enable = true;
  };

  virtualisation.oci-containers.containers."open-webui" = {
    image = "ghcr.io/open-webui/open-webui:0.3.32";
    volumes = [ "open-webui:/app/backend/data" ];
    ports = [ "8080:8080" ];
    extraOptions = [ "--network=host" ];
    environment = {
      WEBUI_AUTH = "False";
    };
  };
}
