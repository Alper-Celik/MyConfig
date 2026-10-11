{
  inputs,
  config,
  my-lib,
  specialArgs,
  ...
}:
let
  current-dir = "Configs/Omp";
  outOfStrore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);

  # sops secrets (MyConfigSecrets): keys under `omp:` —
  # omp/openrouter_api_key, omp/hermes_api_key, omp/hermes_mcp_ssh_private_key.
  # The decrypted openrouter/hermes keys are read by the key scripts in this
  # directory, which models.yml references through its `apiKey: "!script"`
  # hooks; the ssh key is installed straight into the omp state dir.
  # Paths deliberately live under ~/.omp/agent instead of /run/user — the
  # omp agent's firejail sandbox whitelists ${HOME}/.omp, so it can read its
  # own secrets; the parent dir is 0700 and the files 0600.
  sopsSecrets = {
    omp-openrouter-api-key = {
      key = "omp/openrouter_api_key";
      mode = "0600";
      path = ".omp/agent/secrets/openrouter-api-key";
    };
    omp-hermes-api-key = {
      key = "omp/hermes_api_key";
      mode = "0600";
      path = ".omp/agent/secrets/hermes-api-key";
    };
    omp-hermes-mcp-ssh-key = {
      key = "omp/hermes_mcp_ssh_private_key";
      mode = "0600";
      path = ".omp/agent/ssh/hermes-mcp";
    };
    omp-github-mcp-authorization = {
      key = "omp/github_mcp_authorization";
      mode = "0600";
      path = ".omp/agent/secrets/github-mcp-authorization";
    };
  };
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    defaultSopsFile = "${inputs.MyConfigSecrets}/secrets/secrets.yaml";
    # user age key, symlinked from the system sops secret by Secrets.os.nix
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    # Keep the whole decrypt chain under ~/.omp/agent — the omp agent's
    # firejail sandbox whitelists ${HOME}/.omp, so the secrets are readable
    # there and nowhere else needs opening up. defaultSecretsMountPoint holds
    # the tmpfs generations defaultSymlinkPath/<name> symlink into.
    defaultSymlinkPath = "${config.home.homeDirectory}/.omp/agent/secrets";
    defaultSecretsMountPoint = "${config.home.homeDirectory}/.omp/agent/.sops-generations";
    secrets = sopsSecrets;
  };

  # omp (llm.omp) reads its config from ~/.omp/agent. The declarative files
  # live here and are symlinked out-of-store so edits apply without a rebuild;
  # the rest of ~/.omp/agent (databases, sessions, cache) is runtime state.
  home.file.".omp/agent/config.yml".source = outOfStrore "config.yml";
  home.file.".omp/agent/models.yml".source = outOfStrore "models.yml";
  # mcp.json IS tracked: secret values in it use `!command` header hooks
  # (resolved per-connect by omp, never stored in the file). Requires the
  # omp/github_mcp_authorization sops secret below.
  home.file.".omp/agent/mcp.json".source = outOfStrore "mcp.json";
  home.file.".omp/agent/AGENTS.md".source = outOfStrore "AGENTS.md";
  home.file.".omp/agent/ssh/config".source = outOfStrore "ssh/config";

  # key hooks referenced by models.yml (paths are load-bearing there).
  # .text instead of out-of-store symlinks: the executable flag makes HM copy
  # the source, and cp would dereference an out-of-store symlink to /home
  # inside the build sandbox. Content is a stable one-liner per script.
  home.file.".omp/agent/openrouter-key.sh" = {
    text = ''
      #!/bin/sh
      # Prints the OpenRouter API key for omp (sops-decrypted, Configs/Omp).
      cat "$HOME/.omp/agent/secrets/openrouter-api-key"
    '';
    executable = true;
  };
  home.file.".omp/agent/hermes-key.sh" = {
    text = ''
      #!/bin/sh
      # Prints the Hermes gateway API key for omp (sops-decrypted, Configs/Omp).
      cat "$HOME/.omp/agent/secrets/hermes-api-key"
    '';
    executable = true;
  };
}
