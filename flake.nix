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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # for QoL improvements in installer ISO
    nixos-images.url = "github:nix-community/nixos-images";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    authorized-keys = {
      url = "https://github.com/STommydx.keys";
      flake = false;
    };
  };

  outputs =
    {
      self,
      darwin,
      home-manager,
      nixpkgs,
      nixos-generators,
      treefmt-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;
      defaultSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      eachSystem = lib.genAttrs defaultSystems;
      nixosHosts = [
        "desktopdx"
        "gitdx"
        "workpcdx"
        "winpcdx"
        "sysspcdx"
        "bastiondx"
      ];
      darwinHosts = [
        "macbookdx"
      ];
      homeManagerHosts = [
        "CLEA-DELL-001" # company machine
        "devdx"
        "syoi"
      ];
      treefmtEval = eachSystem (
        system: treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix
      );
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

      darwinConfigurations = builtins.listToAttrs (
        builtins.map (host: {
          name = host;
          value = darwin.lib.darwinSystem {
            modules = [
              ./hosts/darwin/${host}
            ];
            specialArgs = { inherit inputs; };
          };
        }) darwinHosts
      );

      homeConfigurations =
        let
          system = "x86_64-linux";
        in
        builtins.listToAttrs (
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
        installer-iso = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos/installer-iso
          ];
          specialArgs = { inherit inputs; };
          format = "install-iso";
        };
        # bastiondx = nixos-generators.nixosGenerate {
        #   inherit system;
        #   modules = [
        #     ./config/linux/hosts/bastiondx/configuration.nix
        #   ];
        #   format = "proxmox-lxc";
        # };
      };

      formatter = eachSystem (system: treefmtEval.${system}.config.build.wrapper);

      checks =
        eachSystem (system: {
          formatting = treefmtEval.${system}.config.build.check self;
        })
        // {
          # checks for darwin hosts
          aarch64-darwin = builtins.mapAttrs (
            host: darwinConfiguration: darwinConfiguration.system
          ) outputs.darwinConfigurations;

          # checks for home-manager hosts
          x86_64-linux = builtins.mapAttrs (
            host: homeConfiguration: homeConfiguration.activationPackage
          ) outputs.homeConfigurations;
        };

    };
}
