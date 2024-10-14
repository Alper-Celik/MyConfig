{ ... }:
{
  services.ollama = {
    enable = true;
  };

  services.open-webui = {
    enable = true;
    environment = {
      # Disable authentication
      WEBUI_AUTH = "False";
    };
  };
}
