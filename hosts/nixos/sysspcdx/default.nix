{ inputs, ... }:

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

  networking.hostName = "sysspcdx";
}
