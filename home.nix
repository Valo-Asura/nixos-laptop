{ config, pkgs, inputs, ... }: {
  imports = [
    ./asuraLaptop/hyprland/default.nix
    ./asuraLaptop/hyprpanel/default.nix
    ./asuraLaptop/wofi/default.nix
    ./asuraLaptop/scripts/screenshot.nix
    ./asuraLaptop/scripts/nightShift.nix
    ./asuraLaptop/tmux/tmux.nix
    ./asuraLaptop/ags/ags.nix
  ];

  home.username = "asura";

  home.packages = with pkgs; [
    home-manager
    hyprpanel
    wofi
    inputs.zen-browser.packages.${pkgs.system}.default
  ];

  #git
  programs.git = {
      enable = true;
      userName = "Valo-Asura";
      userEmail = "vimalranghar016@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = "/etc/nixos/";
      };
  };
  

  home.pointerCursor = {
    gtk.enable = true;
    #x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 18;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Green-Dark";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  # Enable Home Manager
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
