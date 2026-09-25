# Hermes Agent

The agent lives on the server (`MyServers`, host `hetzner-server-1`) and keeps
the memory, the skills and the sessions there. These machines are windows into
it, over ssh. Nothing in this directory runs a second gateway — the
`services.hermes-agent` module stays disabled here on purpose, so every surface
(dashboard, Telegram, CLI) talks to the same brain.

| File | What it does |
| --- | --- |
| `Hermes.home.nix` | hermes CLI + desktop application from the `hermes-agent` flake input, the ssh entry for the server, and the `hermes-hetzner` wrapper |
| `Hermes.os.nix` | the `hermes-agent` account the agent on the server uses to ssh into these machines |

## This machine → the agent on the server

```bash
hermes-hetzner              # interactive CLI
hermes-hetzner --tui        # Ink TUI
hermes-hetzner -q "..."     # one-shot
```

It runs `ssh -t hetzner-server-1 hermes …`, i.e. the CLI under the server's
`hermes` account, where `HERMES_HOME` is `/var/lib/hermes/.hermes` — the same
sessions, skills and memory the gateway uses.

The desktop application (`hermes-desktop`) reaches the same agent through its
own connection registry: **Settings → Gateways → Add connection → SSH**, host
`hermes@hetzner-server-1`, any name (e.g. `Homelab`). The app opens the tunnel
and starts the dashboard on the server itself; the token is adopted over the
tunnel, so the token fields stay empty. That registry lives in the app's
user-data directory with encrypted token envelopes, so it is not managed here —
one click-through per machine.

### One prerequisite, on the server side (MyServers)

The `hermes` account on `hetzner-server-1` has no `authorized_keys` yet, so
neither of the two entry points above connects until this machine's public key
is authorised for it:

```nix
# hetzner/server-1/hermes.nix — then `deploy .#hetzner-server-1`
users.users.hermes.openssh.authorizedKeys.keys = [
  # this machine's ~/.ssh/id_ed25519.pub
  "ssh-ed25519 AAAA… alper@alper-celik.dev"
];
```

Alper's key is already trusted by `root` through `trusted-ssh-keys`; the agent
account is kept separate on purpose, and only it can reach the agent's state.

## The agent on the server → this machine

`users.users.hermes-agent` is a plain, non-`wheel` account: the agent on
`hetzner-server-1` ssh's in as `hermes-agent@<host>` with the key that lives at
`/var/lib/hermes/.ssh/id_ed25519` on the server (label
`hermes-agent@hetzner-server-1`, fingerprint
`SHA256:qAlE/7uexhN0HAwOya+k9DF8wVgmxY3Tyi8QBabhd3c`). No sudo, no password
(`users.mutableUsers = false`), and `Configs/sshd.os.nix` keeps sshd on the
tailnet only.

Sanity check from the server:

```bash
ssh -o BatchMode=yes hermes-agent@strix-scar-17 true
```

To let it work on files here, give the account an ACL instead of a chown — the
same shape the rest of this config uses:

```nix
# example: read/write on a projects directory
systemd.tmpfiles.rules = [ "A /home/alper/Projects - - - - user:hermes-agent:rwX" ];
```

Drop a machine from the list in `Hermes.os.nix` (`enabledHosts`) to keep the
account off it.

## Troubleshooting

- `ssh -v hetzner-server-1` — is the key the one authorised on the server?
- `ssh hermes@hetzner-server-1 hermes --version` — does the CLI resolve over a
  non-interactive ssh (`hermes` is on the system PATH on the server via
  `addToSystemPackages`)?
- `systemctl status sshd` on a machine that the agent cannot reach — the
  account exists only after a rebuild that includes `Hermes.os.nix`.
- The desktop app's SSH connection needs `hermes` on the *remote* PATH; if it
  reports "Hermes is not installed on the remote host", set the Hermes path
  field to `/run/current-system/sw/bin/hermes`.
