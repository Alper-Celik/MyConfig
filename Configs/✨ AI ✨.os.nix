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
  environment.sessionVariables = {
    OPENCODE_ENABLE_EXA = 1; # enable web search
    OPENCODE_CONFIG = pkgs.writeText "opencode-config" (
      builtins.toJSON {
        "$schema" = "https://opencode.ai/config.json";
        permission = {
          bash = "ask";
        };

        provider = {
          "ollama" = {
            "npm" = "@ai-sdk/openai-compatible";
            "name" = "Ollama";
            "options" = {
              "baseURL" = "http://localhost:${builtins.toString config.services.ollama.port}/v1";
            };
            "models" = {
              "qwen3.5=9b" = {
                "name" = "qwen3.5:9b";
              };
            };
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
    package = pkgs-unstable.ollama-cuda;
    enable = true;
    user = "ollama";
    group = user;
  };

}
