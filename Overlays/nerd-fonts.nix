final: prev: {
  nerd-fonts = prev.nerd-fonts // {
    jetbrains-mono = prev.runCommand prev.nerd-fonts.jetbrains-mono.name { } ''
      mkdir -p $out/share/fonts/truetype/NerdFonts/
      cp -a ${prev.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/* $out/share/fonts/truetype/NerdFonts/
    '';
  };
}
