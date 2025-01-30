{ inputs, config, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko
    ../../../profiles/nixos/base
    ../../../systems/proxmox-vm
    ../../../users/stommydx
    ./disk-config.nix
    ./hardware-configuration.nix
    ./backup.nix
    ./forgejo.nix
    ./ingress.nix
    ./litestream.nix
    ./opengist.nix
  ];

  networking.hostName = "gitdx";

  users.users.git = {
    description = "System user for managing git related services";
    group = "git";
    isSystemUser = true;
    home = config.services.forgejo.stateDir;
  };
  users.groups.git = { };

}
