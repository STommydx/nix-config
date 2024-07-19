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

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
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

  outputs = { self, darwin, nixos-wsl, home-manager, nix-index-database, sops-nix, nixos-generators, nixpkgs, nixvim }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        desktopdx = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./config/linux-desktop/hosts/desktopdx/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.stommydx = {
                imports = [
                  ./config/linux-desktop/home.nix
                  nixvim.homeManagerModules.nixvim
                ];
              };
            }
            nix-index-database.nixosModules.nix-index
            sops-nix.nixosModules.sops
          ];
        };
        winpcdx = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixos-wsl.nixosModules.default
            ./config/wsl/hosts/winpcdx/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.stommydx = {
                imports = [
                  ./config/wsl/home.nix
                  nixvim.homeManagerModules.nixvim
                ];
              };
            }
            nix-index-database.nixosModules.nix-index
            sops-nix.nixosModules.sops
          ];
        };
      };
      darwinConfigurations = {
        macbookdx = darwin.lib.darwinSystem {
          modules = [
            ./config/mac/hosts/macbookdx/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.stommydx = {
                imports = [
                  ./config/mac/home.nix
                  nixvim.homeManagerModules.nixvim
                ];
              };
            }
          ];
        };
      };
      homeConfigurations = {
        syoi = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./config/linux/hosts/syoi/home.nix
            nix-index-database.hmModules.nix-index
            nixvim.homeManagerModules.nixvim
          ];
        };
      };
      packages.x86_64-linux = {
        iso = nixos-generators.nixosGenerate {
          inherit system;
          modules = [
            ./config/linux/configuration.minimal.nix
          ];
          format = "install-iso";
        };
      };
    };
}
