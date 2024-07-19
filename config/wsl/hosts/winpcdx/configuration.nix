{ config, pkgs, lib, ... }:

{
  imports = [
    ../../configuration.nix
  ];

  networking.hostName = "winpcdx";
}
