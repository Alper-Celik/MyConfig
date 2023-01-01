{ inputs, lib, config, pkgs, pkgs-u, pkgs-s, specialArgs, ... }: {
  home.file =
    {
      ".aliases".source = ./.aliases;
    };
}
