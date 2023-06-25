{ pkgs, ... }:
{
  environment.systemPackages = with pkgs;[
    picom-next
    alsa-utils
  ];

  services.xserver = {
    extraConfig = ''
      Section "InputClass"
      	Identifier "My Mouse"
      	Driver "libinput"
      	MatchIsPointer "yes"
      	Option "AccelProfile" "flat"
      	Option "AccelSpeed" "0"
      EndSection
    '';
    xkbOptions = "caps:escape_shifted_capslock";
    windowManager.qtile = {
      enable = true;
      backend = "x11";
      extraPackages = import ./python-pkgs.nix;
    };
  };
} 
