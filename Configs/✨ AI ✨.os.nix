{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  # Install opencode as a system package for AI services
  environment.systemPackages = with pkgs; [
    opencode
  ];

  environment.persistence."/persistent".directories = [
    {
      directory = "/var/lib/private/ollama";
      user = "ollama";
      group = "ollama";
      mode = "u=rwx,g=rx,o=rx";
    }
  ];

  # FIXME: systemd creates problems fix in near future
  services.ollama = rec {
    package = pkgs-unstable.ollama-cuda;
    enable = true;
    user = "ollama";
    group = user;
  };

}
