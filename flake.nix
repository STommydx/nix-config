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
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      darwin,
      nixos-wsl,
      home-manager,
      nix-index-database,
      sops-nix,
      nixos-generators,
      nixpkgs,
      nixvim,
      stylix,
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        desktopdx = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            ./config/linux-desktop/hosts/desktopdx/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.stommydx = {
                imports = [
                  ./profiles/homeManager/alltheway-desktop
                ];
              };
              # Special thanks to random guy on reddit!
              # https://www.reddit.com/r/NixOS/comments/1bqzg78/pass_specialargs_into_extraspecialargs_when_using/
              home-manager.extraSpecialArgs = specialArgs;
            }
            nix-index-database.nixosModules.nix-index
            sops-nix.nixosModules.sops
            stylix.nixosModules.stylix
          ];
          specialArgs = { inherit inputs; };
        };
        workpcdx = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            ./config/linux-desktop/hosts/workpcdx/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.stommydx = {
                imports = [
                  ./profiles/homeManager/devops-desktop
                ];
              };
              home-manager.extraSpecialArgs = specialArgs;
            }
            nix-index-database.nixosModules.nix-index
            sops-nix.nixosModules.sops
            stylix.nixosModules.stylix
          ];
          specialArgs = { inherit inputs; };
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
        sysspcdx = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixos-wsl.nixosModules.default
            ./config/wsl/hosts/sysspcdx/configuration.nix
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
          specialArgs = { inherit inputs; };
        };
        bastiondx = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            "${nixpkgs}/nixos/modules/virtualisation/proxmox-lxc.nix"
            ./config/linux/hosts/bastiondx/configuration.nix
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
            nix-index-database.darwinModules.nix-index
          ];
        };
      };
      homeConfigurations = {
        syoi = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./config/linux/hosts/syoi/home.nix
            ./profiles/homeManager/devops
            nix-index-database.hmModules.nix-index
            nixvim.homeManagerModules.nixvim
          ];
          specialArgs = { inherit inputs; };
        };
        devdx = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./profiles/homeManager/devops
            nix-index-database.hmModules.nix-index
            nixvim.homeManagerModules.nixvim
          ];
          specialArgs = { inherit inputs; };
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
        bastiondx = nixos-generators.nixosGenerate {
          inherit system;
          modules = [
            ./config/linux/hosts/bastiondx/configuration.nix
          ];
          format = "proxmox-lxc";
        };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
