{ ... }:
{
  programs.oh-my-posh = {
    enable = true;
    enableFishIntegration = true;
    settings = builtins.fromJSON (builtins.readFile ./config.json);
  };
}
