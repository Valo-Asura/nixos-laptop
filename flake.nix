{
  description = "NixOS system configuration for Asura";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    hyprpolkitagent.url = "github:hyprwm/hyprpolkitagent";
    ags.url = "github:aylur/ags";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    zen-browser.url = "git+https://git.sr.ht/~canasta/zen-browser-flake/";
  };
  outputs = { self, nixpkgs, hyprland, hyprland-plugins, home-manager, hyprpanel, ags, ... }@inputs: 
    let
      system = "x86_64-linux";
      hostname = "nixos";
      username = "asura";
      stateVersion = "24.11";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { 
          inherit system;
          inherit inputs; 
          inherit username;
          inherit hostname;
        };
        modules = [
          ./asuraLaptop/system/default.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ #for hyprpanel
              inputs.hyprpanel.overlay 
            ];
            
              home-manager.extraSpecialArgs = {
                inherit username;
                inherit inputs;
                inherit hostname;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./home.nix;
          }

        ];
      };
    };
}