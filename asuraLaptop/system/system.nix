{ config, pkgs, inputs, ... }: {
  # Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # system packages
  environment.systemPackages = with pkgs; [
    
      # home-manager

      # beauty cosmitic
      microfetch #sysinfo on terminal
      
      # Terminal
      kitty zsh superfile #fancy file manager
      #fzf # fuzzy finder
      
      # System Tools
      polkit lxqt.lxqt-policykit
      gvfs udisks2 udiskie
      lm_sensors brightnessctl
      
      # File Management
      xfce.thunar xfce.thunar-volman
      xfce.tumbler xarchiver
      shared-mime-info pcmanfm
      gvfs ripgrep fzf
      
      # Desktop Environment
      waybar swaybg swww
      wlogout 
      xdg-utils swaylock kdePackages.qt6ct 
      networkmanager
      
      # Multimedia
      playerctl vlc
      firefox-wayland
      librewolf

      #for hyprpanel
        wireplumber
        libgtop
        bluez
        dart-sass
        wl-clipboard
        upower
        gvfs
        matugen
        
      #optional hyprpanel
        swappy
        power-profiles-daemon
        hyprsunset
        hypridle
        btop
        grimblast
        gpu-screen-recorder

      #ags
      # ags
      # gtksourceview3
      # bun
      
      # fd
      # libnotify
      
      # Development
      vscode wget

      # Python
      (python311.withPackages (ps: with ps; [
        pip
        requests
      ]))
    ];


    environment.variables = {
    # Your existing variables...
    CMAKE_PREFIX_PATH = "/run/current-system/sw";
    CPATH = "/run/currencdt-system/sw/include";
    LD_LIBRARY_PATH = "/run/current-system/sw/lib";
};

  # #ags
  nixpkgs.overlays = [
    (final: prev:
    {
      ags = prev.ags.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ pkgs.libdbusmenu-gtk3 pkgs.ddcutil ];
      });
    })
  ];

  #enable upower
  services.upower.enable = true;

  services.blueman.enable = true;  # Bluetooth support for hyprpanel
  hardware.bluetooth.enable = true;
  services.dbus.enable = true;
  
  # Default Applications
  environment.etc."xdg/mime/defaults.list" = {
    text = ''
      [Default Applications]
      inode/directory=thunar.desktop
      application/x-compressed-tar=xarchiver.desktop
    '';
  };
  
  # Wayland Environment Variables
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    GDK_BACKEND = "wayland,x11";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };
  
  
  # Theming and Integration
   # Enable dark theme (GTK and Qt)
  environment.variables = {
    GTK_THEME = "Flat-Remix-GTK-Green-Dark";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };
  
  # Qt theme settings
  qt = {
    platformTheme = "qt6ct";
    style = "gtk2";  
  };
  
  # Additional Services
  services = {
    udisks2.enable = true;
    gvfs.enable = true;
    power-profiles-daemon.enable = true;
  };
  
  #Udiskie Service
  systemd.user.services.udiskie = {
    description = "Udiskie Daemon";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.udiskie}/bin/udiskie --no-notify";
      Restart = "always";
      RestartSec = 10;
    };
  };

  # Printing services
  services.printing.enable = true;

  # Sound system with Pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Install Firefox browser
  programs.firefox.enable = true;

  # Allow unfree packages (required for NVIDIA drivers)
  nixpkgs.config.allowUnfree = true;

  programs.ssh = {
    startAgent = true;
  };

  # Fonts configuration
  fonts.packages = with pkgs; [
    fira
    fira-code-symbols
    nerdfonts
  ];
  fonts.fontconfig.enable = true;

 
  # NVIDIA driver configuration
  hardware.graphics.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem pkg [
      "nvidia_x11"
    ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;  # Use proprietary NVIDIA driver
    nvidiaSettings = true;  # Enable NVIDIA settings tool
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # Garbage collection to clean unused packages
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Automatic system updates from NixOS unstable channel
  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-24.11";
  };

  # System state version
  system.stateVersion = "24.11";
}
