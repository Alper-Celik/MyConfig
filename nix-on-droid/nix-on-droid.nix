{
  config,
  lib,
  pkgs,
  my-pkgs,
  specialArgs,
  inputs,
  ...
}:

{

  # Simply install just the packages
  environment.packages =
    # (import ../Programs/Cli/program-list.nix { inherit pkgs my-pkgs; }) ++ #FIXME: fix this when my cli programs needed in nix-on-droid
    [ pkgs.pinentry-curses ];
  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "22.05";

  home-manager.extraSpecialArgs = specialArgs;
  home-manager.config = ../home-manager/home.nix;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [
    inputs.stylix.homeModules.stylix
    # No graphical session on the phone: keep the terminal/tooling modules only.
    { x-headless = true; }
    {
      home.file.gpg-config = {
        target = ".gnupg/gpg-agent.conf";
        text = "pinentry-program ${pkgs.pinentry-curses}/bin/pinentry";
      };
    }
  ];
  home-manager.backupFileExtension = "backup";

  # Set up nix for flakes
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    # settings = { } // specialArgs.caches;

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    # registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    #nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;                     };

  };

  # Set your time zone
  time.timeZone = "Europe/Istanbul";

  user.shell = "${pkgs.writeShellScriptBin "init.sh" ''
    ${pkgs.fish}/bin/fish -C "export GPG_TTY=$(tty)"
  ''}/bin/init.sh";
  terminal.font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMonoNerdFont-BoldItalic.ttf";
}
