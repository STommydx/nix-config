{ inputs, pkgs, ... }:

{
  imports = [
    ../../../profiles/nixos/devops-desktop
    ../../../systems/baremetal-intel
    ../../../users/stommydx
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
  ];

  # Home Manager setting for host
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.stommydx = {
    imports = [
      ../../../profiles/homeManager/devops-desktop
    ];
  };
  home-manager.extraSpecialArgs = { inherit inputs; };

  environment.systemPackages = with pkgs; [
    cfssl # for signing certificates on CLI
    consul
    consul-template
    nomad
    temporal-cli # for managing temporal, durable execution engine
    vault
    wander
  ];

  networking.hostName = "workpcdx";

}
