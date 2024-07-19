{ config, pkgs, lib, ... }:

{
  imports = [
    ./configuration.minimal.nix
    ../shared/configuration.nix
  ];
}
