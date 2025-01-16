{
  inputs,
  lib,
  pkgs,
  ...
}:

{

  imports = [
    ../../../profiles/nixos/ops
    ../../../systems/proxmox-lxc
    ../../../users/stommydx
    inputs.home-manager.nixosModules.home-manager
  ];

  # Home Manager setting for host
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.stommydx = {
    imports = [
      ./profiles/homeManager/ops
    ];
  };
  home-manager.extraSpecialArgs = { inherit inputs; };

  networking.hostName = "winpcdx";

  # disable network manager for wsl to manage interfaces for mirrored netword mode
  networking.networkmanager.enable = lib.mkForce false;

  # services run on bastion host
  services.adguardhome = {
    enable = true;
  };
  services.caddy = {
    enable = true;
  };

  users.users.root = {
    shell = pkgs.zsh;
  };

}
