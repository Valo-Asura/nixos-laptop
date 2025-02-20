# good enough tiling manager
{ pkgs, config, inputs, ... }:
let
  border-size = 1;
  gaps-in = 2;
  gaps-out = 6;
  active-opacity = 1;
  inactive-opacity = 0.89;
  rounding = 8;
  blur = true;
  keyboardLayout = "us";
  border-color= "rgb(b4befe)";
in {

  imports = [
    ./animations.nix
    ./bindings.nix
    ./polkitagent.nix
    ./hypridle.nix
  ];

  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    qt6ct
    brightnessctl  
    libva
    dconf
    wayland-utils
    wayland-protocols
    glib
    direnv
    meson
    cpio
    cmake
    cpio
  ];
  
  wayland.windowManager.hyprland = {
    enable = true;
    #package = inputs.hyprland.packages.${pkgs.system}.default;
    plugins = [
      pkgs.hyprlandPlugins.hyprexpo
    ];
    xwayland.enable = true;  
    settings = {
      "$mod" = "SUPER";
      "$shiftMod" = "SUPER_SHIFT";

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user start hyprpolkitagent"
        "hyprpanel"
        "code"
        #"lxqt-policykit-agent"
      ];

      monitor = [
        "eDP-1,highres,0x0,1"
        "DP-7, disable"
        "DP-8, disable"
        "DP-9, disable"
        "HDMI-A-1,3440x1440@99.98,auto,1"
        ",prefered,auto,1"
      ];

      env = [
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "MOZ_ENABLE_WAYLAND,1"
        "ANKI_WAYLAND,1"
        "DISABLE_QT5_COMPAT,0"
        "NIXOS_OZONE_WL,1"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM=wayland,xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "__GL_GSYNC_ALLOWED,0"
        "__GL_VRR_ALLOWED,0"
        "DISABLE_QT5_COMPAT,0"
        "DIRENV_LOG_FORMAT,"
        "WLR_DRM_NO_ATOMIC,1"
        "WLR_BACKEND,vulkan"
        "WLR_RENDERER,vulkan"
        "XDG_SESSION_TYPE,wayland"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
        "AQ_DRM_DEVICES,/dev/dri/card2:/dev/dri/card1" # CHANGEME: Related to the GPU
        "XCURSOR_SIZE,16"
        "XCURSOR_THEME,Bibata-Modern-Classic"
      ];

      cursor = {
        no_hardware_cursors = false;
        default_monitor = "eDP-1";
      };

      general = {
        resize_on_border = true;
        gaps_in = gaps-in;
        gaps_out = gaps-out;
        border_size = border-size;
        border_part_of_window = true;
        layout = "master";
        "col.active_border" = border-color;
      };

      decoration = {
        active_opacity = active-opacity;
        inactive_opacity = inactive-opacity;
        rounding = rounding;
        shadow = {
          enabled = false;
          range = 0;
          render_power = 3;
        };
        blur = { enabled = if blur then "true" else "false"; };
      };

      master = {
        new_status = true;
        allow_small_split = true;
        mfact = 0.5;
      };

      gestures = { workspace_swipe = true; };

      misc = {
        vfr = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_autoreload = true;
        focus_on_activate = true;
        new_window_takes_over_fullscreen = 2;
      };

      windowrulev2 =
        [ "float, tag:modal" "pin, tag:modal" "center, tag:modal" ];

      layerrule = [ "noanim, launcher" "noanim, ^ags-.*" ];

      input = {
        kb_layout = keyboardLayout;
        kb_options = "caps:escape";
        follow_mouse = 1;
        sensitivity = 0.5;
        repeat_delay = 300;
        repeat_rate = 50;
        numlock_by_default = true;

        touchpad = {
          natural_scroll = true;
          tap_button_map = "lrm";  # Left-Right-Middle button mapping
          clickfinger_behavior = false;
        };
      };

    };
  };
  systemd.user.targets.hyprland-session.Unit.Wants =
    [ "xdg-desktop-autostart.target" ];
}
