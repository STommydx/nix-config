{ inputs, lib, ... }:

{

  imports = [
    ../../../profiles/nixos/devops
    ../../../systems/wsl
    ../../../users/stommydx
    inputs.home-manager.nixosModules.home-manager
  ];

  # Home Manager setting for host
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.stommydx = {
    imports = [
      ../../../profiles/homeManager/devops
    ];
  };
  home-manager.extraSpecialArgs = { inherit inputs; };

  networking.hostName = "winpcdx";

  # disable network manager for wsl to manage interfaces for mirrored netword mode
  networking.networkmanager.enable = lib.mkForce false;

}
