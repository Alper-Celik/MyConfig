{
  pkgs,
  config,
  ...
}:
let

  script = ''
    echo test
    ls "$out"
    for i in $out/share/dotnet/sdk/*
    do
      i=$(basename $i)
      length=$(printf "%s" "$i" | wc -c)
      substring=$(printf "%s" "$i" | cut -c 1-$(expr $length - 2))
      i="$substring""00"

      echo $i

      mkdir -p $out/share/dotnet/metadata/workloads/''${i/-*}
      touch $out/share/dotnet/metadata/workloads/''${i/-*}/userlocal
    done
  '';

  sdkOverride = (
    finalAttrs: previousAttrs: {
      src = (
        previousAttrs.src.overrideAttrs (
          finalAttrs: previousAttrs: {

            postBuild = (previousAttrs.postBuild or '''') + script;
          }
        )
      );
    }
  );
  dotnet-full =
    with pkgs;
    (
      with dotnetCorePackages;
      combinePackages [
        (sdk_9_0.overrideAttrs sdkOverride)
        (sdk_8_0.overrideAttrs sdkOverride)
      ]
    );

in
{
  home.packages = [
    dotnet-full
  ];

  home = {
    sessionPath = [ "${config.home.homeDirectory}/.dotnet/tools/" ];
    sessionVariables = {
      DOTNET_ROOT = "${dotnet-full}/share/dotnet";
      DOTNET_PATH = "${dotnet-full}/bin/dotnet";
    };
  };

}
