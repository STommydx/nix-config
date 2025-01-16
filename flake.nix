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
      home-manager,
      nix-index-database,
      nixos-generators,
      nixpkgs,
      nixvim,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      nixosHosts = [
        "desktopdx"
        "workpcdx"
        "winpcdx"
        "sysspcdx"
        "bastiondx"
      ];
      homeManagerHosts = [
        "CLEA-DELL-001" # company machine
        "devdx"
        "syoi"
      ];
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        builtins.map (host: {
          name = host;
          value = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./hosts/nixos/${host} ];
            specialArgs = { inherit inputs; };
          };
        }) nixosHosts
      );
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
      homeConfigurations = builtins.listToAttrs (
        builtins.map (host: {
          name = host;
          value = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
              ./hosts/homeManager/${host}
            ];
            extraSpecialArgs = { inherit inputs; };
          };
        }) homeManagerHosts
      );
      packages.x86_64-linux = {
        # iso = nixos-generators.nixosGenerate {
        #   inherit system;
        #   modules = [
        #     ./config/linux/configuration.minimal.nix
        #   ];
        #   format = "install-iso";
        # };
        # bastiondx = nixos-generators.nixosGenerate {
        #   inherit system;
        #   modules = [
        #     ./config/linux/hosts/bastiondx/configuration.nix
        #   ];
        #   format = "proxmox-lxc";
        # };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      checks.x86_64-linux = builtins.mapAttrs (
        host: homeConfiguration: homeConfiguration.activationPackage
      ) outputs.homeConfigurations;
    };
}
