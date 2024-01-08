{
  lib,
  self,
  ...
}: {
  home = {
    username = "aayush";
    homeDirectory = "/home/aayush";
    stateVersion = "23.11";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      lib = prev.lib // {colors = import "${self}/lib/colors" lib;};
    })
  ];
}