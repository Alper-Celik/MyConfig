(final: prev: {
  mutter = prev.mutter.overrideAttrs (old: {
    src = prev.pkgs.fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "vanvugt";
      repo = "mutter";
      rev = "triple-buffering-v4-46";
      hash = "sha256-C2VfW3ThPEZ37YkX7ejlyumLnWa9oij333d5c4yfZxc=";
    };
  });
})
