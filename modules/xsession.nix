{ config, pkgs, ... }:

# most of X configuration

{
  # manage monitor configurations
  programs.autorandr = {
    enable = true;
    profiles.home = {
      fingerprint = {
        DVI-D-0 =
          "00ffffffffffff00410cafc06d37000005170103802917782abe05a156529d270c5054bd4b00818081c0010101010101010101010101662156aa51001e30468f33009ae61000001e000000ff00554b3031333035303134313839000000fc005068696c697073203139365634000000fd00384c1e530e000a20202020202000ba";
        HDMI-0 =
          "00ffffffffffff0009d1ea78455400000b1e010380301b782eb065a656539d280c5054a56b80d1c081c081008180a9c0b30001010101023a801871382d40582c4500dc0c1100001e000000ff0045334c30373535303031390a20000000fd00324c1e5311000a202020202020000000fc0042656e5120424c323238330a200193020322f14f901f05140413031207161501061102230907078301000065030c001000023a801871382d40582c4500dc0c1100001e011d8018711c1620582c2500dc0c1100009e011d007251d01e206e285500dc0c1100001e8c0ad08a20e02d10103e9600dc0c1100001800000000000000000000000000000000000000000081";
      };
      config = {
        HDMI-0 = {
          enable = true;
          crtc = 1;
          gamma = "1.099:1.0:0.909";
          mode = "1920x1080";
          position = "0x0";
          rate = "60.00";
          primary = true;
        };
        DVI-D-0 = {
          enable = true;
          crtc = 0;
          gamma = "1.099:1.0:0.909";
          mode = "1366x768";
          position = "1920x312";
          rate = "59.79";
        };
      };
      hooks.postswitch = "systemctl --user restart random-background polybar";
    };
  };

  # notification daemon
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    settings = {
      global = {
        follow = "mouse";
        geometry = "350x5-4+32";
        indicate_hidden = "yes";
        shrink = "yes";
        separator_height = 1;
        padding = 8;
        horizontal_padding = 8;
        frame_width = 2;
        icon_position = "left";
        max_icon_size = 64;
        font = "Noto Sans 10";
        format = ''
          <b>%s</b> | %a
          %b'';
        separator_color = "auto";
        markup = "full";
        alignment = "center";
        vertical_alignment = "center";
        word_wrap = "yes";
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
        show_indicators = false;
      };

      fullscreen_delay_everything = { fullscreen = "delay"; };
      urgency_critical = {
        background = "#16161c";
        foreground = "#fdf0ed";
        frame_color = "#e95678";
      };
      urgency_low = {
        background = "#16161c";
        foreground = "#fdf0ed";
        frame_color = "#29d398";
      };
      urgency_normal = {
        background = "#16161c";
        foreground = "#fdf0ed";
        frame_color = "#fab795";
      };
    };
  };

  services.picom = {
    enable = true;
    blur = true;
    blurExclude = [
      "class_g = 'slop'"
      "class_g = 'Firefox'"
    ];
    experimentalBackends = true;
    extraOptions = ''
      # improve performance
      glx-no-rebind-pixmap = true;

      glx-no-stencil = true;

      # fastest swap method
      glx-swap-method = 1;

      # dual kawase blur
      blur-background-fixed = false;
      blur-method = "dual_kawase";
      blur-strength = 10;

      use-ewmh-active-win = true;
      detect-rounded-corners = true;

      # stop compositing if there's a fullscreen program
      unredir-if-possible = true;

      # group wintypes and don't focus a menu (Telegram)
      detect-transient = true;
      detect-client-leader = true;

      # needed for nvidia with glx backend
      xrender-sync-fence = true;
    '';
  };

  services.sxhkd = {
    enable = true;
    keybindings = let rofiScripts = "~/.local/bin/rofi"; in {
      # start terminal
      "super + Return" = "alacritty";
      # application launcher
      "super + @space" = "rofi -show combi";
      # reload sxhkd
      "super + Escape" = "pkill -USR1 -x sxhkd";
      # pause/resume notifications
      "super + ctrl + Escape" = "dunstctl set-paused toggle";
      # bspwm hotkeys
      # quit bspwm normally
      "super + alt + Escape" = "bspc quit";
      # close/kill
      "super + {_,shift + }q" = "bspc node -{c,k}";
      # monocle layout
      "super + m" = "bspc desktop -l next";
      # send the newest marked node to the newest preselected node
      "super + y" = "bspc node newest.marked.local -n newest.!automatic.local";
      # swap the current node and the biggest node
      "super + g" = "bspc node -s biggest";
      # state/flags
      # set the window state
      "super + {t,shift + t,s,f}" =
        "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
      # set the node flags
      "super + ctrl + {m,x,y,z}" =
        "bspc node -g {marked,locked,sticky,private}";
      # focus/swap
      # focus the node in the given direction
      "super + {_,shift + }{h,j,k,l}" =
        "bspc node -{f,s} {west,south,north,east}";
      # focus the next/previous node in the current desktop
      "super + {_,shift + }c" = "bspc node -f {next,prev}.local";
      # focus the next/previous desktop in the current monitor
      "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local";
      # focus the last node/desktop
      "super + {grave,Tab}" = "bspc {node,desktop} -f last";
      # focus or send to the given desktop
      "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";
      # preselect the direction
      "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
      # preselect the ratio
      "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";
      # cancel the preselection for the focused node
      "super + ctrl + space" = "bspc node -p cancel";
      # cancel the preselection for the focused desktop
      "super + ctrl + shift + space" =
        "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";
      # move/resize
      # expand a window by moving one of its side outward
      "super + alt + {h,j,k,l}" =
        "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
      # contract a window by moving one of its side inward
      "super + alt + shift + {h,j,k,l}" =
        "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
      # move a floating window
      "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
      # rotate window layout clockwise 90 degrees
      "super + r" = "bspc node @parent -R 90";
      # increase/decrease borders
      "super + {_, ctrl + } {equal,minus}" =
        "~/.local/bin/dynamic_bspwm.sh {b,g} {+,-}";
      #	programs
      # screenshot curren monitor
      "super + Print" = "~/.local/bin/maim_monitor.sh";
      # screenshot menu
      "Print" = "${rofiScripts}/screenshot.sh";
      # backlight menu
      "super + b" = "${rofiScripts}/backlight.sh";
      # powermenu
      "super + p" = "${rofiScripts}/powermenu.sh";
      # volume menu
      "super + v" = "${rofiScripts}/volume.sh";
      # mpd menu
      "super + shift + m" = "${rofiScripts}/mpd.sh";
      # emoji launcher
      "super + e" = "rofi -show emoji";
      # rofi pass
      "super + i" = "rofi-pass";
      # window switcher
      "alt + Tab" = "rofi -show window";
      # audio controls
      # play/pause
      "{Pause,XF86AudioPlay}" = "playerctl play-pause";
      # next/prev song
      "super + shift + {Right,Left}" = "playerctl {next,previous}";
      # toggle repeat/shuffle
      "super + alt + {r,z}" = "playerctl {loop,shuffle}";
      # volume up/down
      "XF86Audio{Raise,Lower}Volume" = "pulsemixer --change-volume {+,-}5";
      # toggle mute
      "XF86AudioMute" = "pulsemixer --toggle-mute";
    };
  };

  # manage X session
  xsession = {
    enable = true;
    pointerCursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 16;
    };
    preferStatusNotifierItems = true;
    windowManager.bspwm = {
      enable = true;
      monitors = {
        HDMI-0 = [ "一" "二" "三" "四" "五" ];
        DVI-D-0 = [ "六" "七" "八" "九" "十" ];
      };
      rules = {
        "osu!.exe" = {
          desktop = "^3";
          state = "fullscreen";
        };
      };
      settings = {
        border_width = 2;
        window_gap = 8;

        active_border_color = "#e95678";
        focused_border_color = "#16161c";
        normal_border_color = "#fab795";
        presel_feedback_color = "#29d398";

        split_ratio = 0.5;
        borderless_monocle = true;
        gapless_monocle = true;
        single_monocle = true;
      };
    };
  };
}