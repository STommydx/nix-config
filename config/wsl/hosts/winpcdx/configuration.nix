{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../../configuration.nix
  ];

  networking.hostName = "winpcdx";

  # disable network manager for wsl to manage interfaces for mirrored netword mode
  networking.networkmanager.enable = lib.mkForce false;
}
