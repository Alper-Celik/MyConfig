{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, ... }: {
  home.file =
    {
      ".aliases" = ./.aliases;
    };
}
