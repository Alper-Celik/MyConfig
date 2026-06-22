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
    OPENCODE_CONFIG = pkgs.writeText "opencode-config" (
      builtins.toJSON {
        "$schema" = "https://opencode.ai/config.json";
        permission = {
          bash = {
            "*" = "ask";

            # git read-only
            "git status *" = "allow";
            "git log *" = "allow";
            "git diff *" = "allow";
            "git show *" = "allow";
            "git branch *" = "allow";
            "git tag *" = "allow";
            "git remote *" = "allow";
            "git ls-files *" = "allow";
            "git rev-parse *" = "allow";
            "git blame *" = "allow";
            "git config --get *" = "allow";
            "git config --list *" = "allow";
            "git config -l *" = "allow";
            "git stash list *" = "allow";
            "git describe *" = "allow";
            "git merge-base *" = "allow";
            "git for-each-ref *" = "allow";
            "git name-rev *" = "allow";

            # file reading & exploration
            "grep *" = "allow";
            "cat *" = "allow";
            "tail *" = "allow";
            "head *" = "allow";
            "ls *" = "allow";
            "find *" = "allow";
            "wc *" = "allow";
            "sort *" = "allow";
            "uniq *" = "allow";
            "diff *" = "allow";
            "file *" = "allow";
            "readlink *" = "allow";
            "realpath *" = "allow";
            "stat *" = "allow";
            "history *" = "allow";

            # text processing
            "jq *" = "allow";
            "awk *" = "allow";
            "cut *" = "allow";
            "tr *" = "allow";
            "column *" = "allow";

            # system info
            "which *" = "allow";
            "echo *" = "allow";
            "ps *" = "allow";
            "whoami" = "allow";
            "id" = "allow";
            "groups" = "allow";
            "date" = "allow";
            "hostname" = "allow";
            "uname *" = "allow";
            "df *" = "allow";
            "du *" = "allow";
            "uptime" = "allow";
            "free *" = "allow";
            "env" = "allow";
            "printenv *" = "allow";
            "pwd" = "allow";
            "pgrep *" = "allow";
            "lsof *" = "allow";
            "ip *" = "allow";
            "ss *" = "allow";
            "netstat *" = "allow";

            # safe file creation
            "mkdir *" = "allow";
            "touch *" = "allow";

            # package manager read-only
            "npm list *" = "allow";
            "npm config get *" = "allow";
            "cargo metadata *" = "allow";

          };
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
    # package = pkgs-unstable.ollama-cuda;
    enable = true;
    user = "ollama";
    group = user;
  };

}
