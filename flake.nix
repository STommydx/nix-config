{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
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

  outputs = { self, darwin, nixos-wsl, home-manager, sops-nix, nixos-generators, nixpkgs, nixvim }:
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
                  nixvim.homeManagerModules.nixvim
                ];
              };
            }
            sops-nix.nixosModules.sops
          ];
        };
        winpcdx = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixos-wsl.nixosModules.default
            ./configuration.nix
            ./hosts/winpcdx/configuration.nix
            {
              wsl.enable = true;
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.stommydx = {
                imports = [
                  ./home.nix
                  nixvim.homeManagerModules.nixvim
                ];
              };
            }
            sops-nix.nixosModules.sops
          ];
        };
      };
      darwinConfigurations = { };
      homeConfigurations = {
        syoi = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./home.nix
            ./hosts/syoi/home.nix
            nixvim.homeManagerModules.nixvim
          ];
        };
      };
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
