{
  pkgs,
  pkgs-unstable,
  my-lib,
  specialArgs,
  config,
  ...
}:
let

  current-dir = "Configs/Vscode";
  outOfStore =
    x: config.lib.file.mkOutOfStoreSymlink (my-lib.maybeOutOfStore specialArgs current-dir x);
  dotnet-full =
    with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_8_0
      runtime_8_0
      aspnetcore_8_0

      sdk_9_0
      runtime_9_0
      aspnetcore_9_0
    ];

in
{
  home.packages = with pkgs; [
    (pkgs.python3.withPackages (p: [ p.pyside6 ]))
    fzf
    ripgrep
    bat
    dotnet-full
  ];

  home = {
    sessionPath = [ "${config.home.homeDirectory}/.dotnet/tools/" ];
    sessionVariables = {
      DOTNET_ROOT = "${dotnet-full}/share/dotnet";
    };
  };

  programs.vscode = {
    enable = true;
    package = (
      pkgs-unstable.vscode.overrideAttrs (prevAttrs: {
        nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ pkgs.makeWrapper ];
        postFixup =
          prevAttrs.postFixup
          + ''
            wrapProgram $out/bin/code \
              --set DOTNET_ROOT "${dotnet-full}/share/dotnet" \
              --prefix PATH : "~/.dotnet/tools"
          '';
      })
    );
  };

  xdg.configFile.nvim-vscode.source = outOfStore ".";
}
