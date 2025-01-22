{ pkgs, ... }:
{

  # from https://github.com/redxtech/nixfiles/blob/6d7fd17375c5474436079c94c0ad3157531f2799/modules/home-manager/cli/gpg.nix#L101
  # archive https://web.archive.org/web/20240919103739/https://github.com/redxtech/nixfiles/blob/6d7fd17375c5474436079c94c0ad3157531f2799/modules/home-manager/cli/gpg.nix#L101
  # enable gpgme in firefox
  home.file.".mozilla/native-messaging-hosts/gpgmejson.json".source =
    let
      toJSON = pkgs.formats.json { };
    in
    toJSON.generate "gpgmejson.json" {
      name = "gpgmejson";
      description = "JavaScript binding for GnuPG";
      path = "${pkgs.gpgme.dev}/bin/gpgme-json";
      type = "stdio";
      allowed_extensions = [ "jid1-AQqSMBYb0a8ADg@jetpack" ];
    };

  home.packages = [ pkgs.firefoxpwa ];

  programs.firefox = {
    enable = true;
    profiles."ev95osw2.default" = {
      isDefault = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.inTitlebar" = 0;
      };
      userChrome = ''
        /* hides the native tabs */
        #TabsToolbar {
          visibility: collapse;
        }
      '';
    };
    nativeMessagingHosts = with pkgs; [
      gpgme
      kdePackages.plasma-browser-integration
      firefoxpwa
    ];
  };
}
