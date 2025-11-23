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

    deploy-rs = {
      url = "github:serokell/deploy-rs";
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
      deploy-rs,
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
        "guardiandx"
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
        "makcpu1" # GPU dev machine @ HKUST
        "syoi"
      ];
      homeManagerDarwinHosts = [
        "CLEA-MAC-001" # company machine
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
            specialArgs = { inherit inputs outputs; };
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
            specialArgs = { inherit inputs outputs; };
          };
        }) darwinHosts
      );

      homeConfigurations =
        (
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
                extraSpecialArgs = { inherit inputs outputs; };
              };
            }) homeManagerHosts
          )
        )
        // (
          let
            system = "aarch64-darwin";
          in
          builtins.listToAttrs (
            builtins.map (host: {
              name = host;
              value = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.${system};
                modules = [
                  ./hosts/homeManager/${host}
                ];
                extraSpecialArgs = { inherit inputs outputs; };
              };
            }) homeManagerDarwinHosts
          )
        );

      packages.x86_64-linux = {
        # disabled until upstream nixos-images update for package rename
        # `zfsUnstable` to `zfs_unstable`
        # https://github.com/nix-community/nixos-images/blob/be92b53bf066324bcfb695fb69210c851baab086/nix/installer.nix#L22
        # installer-iso = nixos-generators.nixosGenerate {
        #   system = "x86_64-linux";
        #   modules = [
        #     ./hosts/nixos/installer-iso
        #   ];
        #   specialArgs = { inherit inputs outputs; };
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

      deploy.nodes = {
        gitdx = {
          hostname = "10.101.151.229";
          profiles.system = {
            sshUser = "stommydx";
            user = "root";
            interactiveSudo = true;
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.gitdx;
          };
        };
        guardiandx = {
          hostname = "10.101.255.22";
          profiles.system = {
            sshUser = "stommydx";
            user = "root";
            interactiveSudo = true;
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.guardiandx;
          };
        };
      };

      nixosModules.opengist = import ./modules/nixos/opengist;

      formatter = eachSystem (system: treefmtEval.${system}.config.build.wrapper);

      checks =
        eachSystem (
          system:
          (
            {
              formatting = treefmtEval.${system}.config.build.check self;
            }
            // (deploy-rs.lib.${system}.deployChecks self.deploy)
          )
        )
        // {
          # checks for darwin hosts
          aarch64-darwin = builtins.mapAttrs (
            host: darwinConfiguration: darwinConfiguration.system
          ) outputs.darwinConfigurations;

          # checks for home-manager hosts
          # temporary disabled due to error https://github.com/nix-community/home-manager/issues/8202
          # x86_64-linux = builtins.listToAttrs (
          #   builtins.map (host: {
          #     name = host;
          #     value = outputs.homeConfigurations.${host}.activationPackage;
          #   }) homeManagerHosts
          # );
        };

    };
}
