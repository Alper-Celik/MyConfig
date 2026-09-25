{ inputs, pkgs, ... }:
let
  # The agent that owns the memory, the skills and the sessions runs on the
  # server (MyServers, host hetzner-server-1). These machines are windows into
  # it: the CLI and the desktop application come from the hermes-agent flake
  # input, the `services.hermes-agent` gateway stays disabled here so there is
  # only ever one brain.
  server = "hetzner-server-1";
  serverFqdn = "hetzner-server-1.bobtail-stonecat.ts.net";

  # `hermes-hetzner` runs the CLI as the `hermes` account on the server, so
  # HERMES_HOME is /var/lib/hermes/.hermes — the sessions, skills and memory
  # the gateway already uses. Requires this machine's ssh key to be authorised
  # for that account; see README.md.
  remote = pkgs.writeShellApplication {
    name = "hermes-hetzner";
    runtimeInputs = [ pkgs.openssh ];
    text = ''
      exec ssh -t ${server} -- hermes "$@"
    '';
  };
in
{
  imports = [ inputs.hermes-agent.homeManagerModules.default ];

  programs.hermes-agent = {
    enable = true; # `hermes` on PATH, HERMES_HOME = ~/.hermes
    desktop.enable = true; # hermes-desktop plus an XDG launcher entry
  };

  # ssh entry for the server; the identity files come from Configs/ssh.home.nix
  programs.ssh.settings.${server} = {
    hostname = serverFqdn;
    user = "hermes";
  };

  home.packages = [ remote ];
}
