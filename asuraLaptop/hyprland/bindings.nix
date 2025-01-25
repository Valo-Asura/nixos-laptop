{ pkgs, config, inputs,... }: {
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    "$shiftMod" = "SUPER_SHIFT";
    bind = [
      "$mainMod, Q, killactive" # Close window
      "$mainMod, H, exit" # Exit Hyprland
      "$mainMod, F, exec, ${pkgs.pcmanfm}/bin/pcmanfm" # Thunar
      "$mainMod, V, togglefloating" # Toggle Floating
      "$mainMod, J, togglesplit" # Toggle Split
      "$mainMod, B, exec, zen" # Zen-browser
      "$mainMod, T, exec, ${pkgs.kitty}/bin/kitty" # Kitty
      "$mainMod, C, exec, code --enable-features=UseOzonePlatform --ozone-platform=wayland" # VSCode
      "$mainMod, A, exec, pkill wofi || ${pkgs.wofi}/bin/wofi --show drun --hide-on-focus-lost" # Wofi
      "$mainMod, E, exec, ${pkgs.telegram-desktop}/bin/telegram-desktop" # Telegram
      "$mainMod, W, exec, pkill hyprpanel || hyprpanel" # Hyprpanel
      "ALT, TAB, hyprexpo:expo, toggle" 
      "ctrl, l, exec, ${pkgs.swaylock}/bin/swaylock -i /etc/nixos/asuraLaptop/hyprland/lock-images/lockscreen.png --ignore-empty-password --color=000000 --scaling=center --show-failed-attempts" # Lock screen

      "$shiftMod,C, exec, clipboard" # Clipboard picker with wofi
      "$shiftMod,E, exec, ${pkgs.wofi-emoji}/bin/wofi-emoji" # Emoji picker with wofi
      "$mod,F2, exec, night-shift" # Toggle night shift
    ] ++ (builtins.concatLists (builtins.genList (i:
      let ws = i + 1;
      in [
        "$mod,code:1${toString i}, workspace, ${toString ws}"
        "$mod SHIFT,code:1${toString i}, movetoworkspace, ${toString ws}"
      ]) 9));

    bindm = [
      "$mod,mouse:272, movewindow" # Move Window (mouse)
      "$mod,mouse:273, resizewindow" # Resize Window (mouse)
      "$mod,TAB, resizewindow" # Resize Window (mouse)
    ];

    bindl = [
      ",XF86AudioMute, exec, sound-toggle" # Toggle Mute
      ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause" # Play/Pause Song
      ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next" # Next Song
      ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous" # Previous Song
      ",switch:Lid Switch, exec, ${pkgs.hyprlock}/bin/hyprlock" # Lock when closing Lid
    ];

    bindle = [
      ",XF86AudioRaiseVolume, exec, sound-up" # Sound Up
      ",XF86AudioLowerVolume, exec, sound-down" # Sound Down
      ",XF86MonBrightnessUp, exec, brightness-up" # Brightness Up
      ",XF86MonBrightnessDown, exec, brightness-down" # Brightness Down
    ];

  };
}
