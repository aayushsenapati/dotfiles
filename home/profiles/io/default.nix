{
  imports = [
    ../../editors/helix
    ../../editors/neovim
    ../../programs
    ../../programs/games.nix
    ../../programs/dunst.nix
    ../../services/cinny.nix
    ../../services/kdeconnect.nix
    ../../services/power-monitor.nix
    ../../wayland
    ../../terminals/alacritty.nix
    ../../terminals/wezterm.nix
  ];

  home.sessionVariables = {
    GDK_SCALE = "2";
  };

  wayland.windowManager.hyprland.settings = let
    accelpoints = "0.21 0.000 0.040 0.080 0.140 0.200 0.261 0.326 0.418 0.509 0.601 0.692 0.784 0.875 0.966 1.058 1.149 1.241 1.332 1.424 1.613";
  in {
    monitor = [
      "DP-1, preferred, -1920x0, auto"
      "DP-2, preferred, -1920x0, auto"
      "eDP-1, preferred, auto, 1.600000"
    ];

    "device:elan2841:00-04f3:31eb-touchpad" = {
      accel_profile = "custom ${accelpoints}";
      scroll_points = accelpoints;
      natural_scroll = true;
    };
  };
}
