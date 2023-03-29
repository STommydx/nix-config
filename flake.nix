{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = github:pta2002/nixvim;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, darwin, home-manager, hyprland, sops-nix, nixos-generators, nixpkgs, nixvim }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        desktopdx = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.desktop.nix
            ./hosts/desktopdx/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.stommydx = {
                imports = [
                  ./home.desktop.nix
                  hyprland.homeManagerModules.default
                  nixvim.homeManagerModules.nixvim
                ];
              };
            }
            hyprland.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
      };
      darwinConfigurations = { };
      homeConfigurations = { };
      packages.x86_64-linux = {
        iso = nixos-generators.nixosGenerate {
          inherit system;
          modules = [
            ./configuration.minimal.nix
          ];
          format = "install-iso";
        };
      };
    };
}
