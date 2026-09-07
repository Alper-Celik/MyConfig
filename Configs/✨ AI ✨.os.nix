{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  # Install opencode as a system package for AI services
  environment.systemPackages = [
    pkgs-unstable.opencode
  ];
  environment.sessionVariables = {
    OPENCODE_ENABLE_EXA = 1; # enable web search
    OPENCODE_EXPERIMENTAL_LSP_TOOL = 1;
    OPENCODE_EXPERIMENTAL_FILEWATCHER = 1;
    OPENCODE_CONFIG = pkgs.writeText "opencode-config" (
      builtins.toJSON {
        "$schema" = "https://opencode.ai/config.json";
        permission = {
          bash = {
            "*" = "ask";
          };
        };
      }
    );
  };

  environment.persistence."/persistent".directories = [
    {
      directory = "/var/lib/private/ollama";
      user = "ollama";
      group = "ollama";
      mode = "u=rwx,g=rx,o=rx";
    }
  ];

  # FIXME= systemd creates problems fix in near future
  services.ollama = rec {
    # package = pkgs-unstable.ollama-cuda;
    enable = true;
    user = "ollama";
    group = user;
  };

}
