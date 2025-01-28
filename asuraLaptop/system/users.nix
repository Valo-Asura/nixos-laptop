 { config, pkgs, ... }: {
    
  # Networking configuration
  networking.hostName = "nixos";  # Define hostname
  networking.networkmanager.enable = true;  # Enable NetworkManager for easier management

 # User configuration
  users.users.asura = {
    isNormalUser = true;
    description = "asura";
    group = "asura";
    extraGroups = [ 
      "networkmanager"
      "wheel"      # Enable sudo
      "storage"    # Access external storage
      "audio"      # Audio device access
      "video"      # For brightness controls and GPU access
      "input"      # Access input devices
      "power"
    ];
  };

  users.groups.asura = {};

}