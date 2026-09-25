{
  lib,
  hardware,
  ...
}:
let
  # Machines the agent on hetzner-server-1 may ssh into. Drop a name to keep
  # the account off that machine.
  enabledHosts = [
    "macbook-m1-alper"
    "strix-scar-17"
    "lenovo-ideapad-510"
  ];

  # Public half of the key that lives on hetzner-server-1 at
  # /var/lib/hermes/.ssh/id_ed25519 (label: hermes-agent@hetzner-server-1,
  # SHA256:qAlE/7uexhN0HAwOya+k9DF8wVgmxY3Tyi8QBabhd3c). The private half never
  # leaves the server.
  agentPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5cCv6Jsy6+D+syem7379dSJTeaGJXRsJIbyhK3Uctr hermes-agent@hetzner-server-1";
in
{
  config = lib.mkIf (builtins.elem hardware enabledHosts) {
    users.users.hermes-agent = {
      isNormalUser = true;
      description = "SSH access for the Hermes agent on hetzner-server-1";
      # Key only: users.mutableUsers = false and no password is set, so the
      # account cannot be logged into with one. sshd is reachable on the
      # tailnet only (Configs/sshd.os.nix).
      openssh.authorizedKeys.keys = [ agentPublicKey ];
      # Deliberately no extraGroups: the agent gets no sudo on these machines.
    };
  };
}
