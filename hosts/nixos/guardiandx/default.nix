{ inputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko
    ../../../profiles/nixos/base
    ../../../systems/proxmox-vm
    ../../../users/stommydx
    ./disk-config.nix
    ./hardware-configuration.nix
    ./adguard.nix
  ];

  networking.hostName = "guardiandx";

}
