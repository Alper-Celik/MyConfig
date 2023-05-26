{ runCommand, hyprland, rsync }:
(runCommand hyprland.name
  {
    inherit hyprland; buildInputs = [ rsync ];
  } ''
  mkdir $out/bin -p
  cd $out/bin
  cp $hyprland/bin/Hyprland ./.Hyprland-wrapped
  echo ". /etc/profile; . /home/alper/.nix-profile/etc/profile.d/hm-session-vars.sh; exec -a \"\$0\" $out/bin/.Hyprland-wrapped \"\$@\"" > Hyprland
  chmod +x ./Hyprland
  cd ..
  rsync -av $hyprland/ $out --exclude Hyprland
'').overrideAttrs (oldAttrs: { passthru = hyprland.passthru; })
