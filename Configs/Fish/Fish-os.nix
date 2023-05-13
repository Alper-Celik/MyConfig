{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fish
    any-nix-shell
  ];
  programs.fish.enable = true;
  programs.fish.promptInit = ''
    any-nix-shell fish --info-right | source
  '';
  users.users.alper.shell = pkgs.fish;
}
