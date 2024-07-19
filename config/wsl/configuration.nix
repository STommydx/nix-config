{ config, pkgs, lib, ... }:

{
  imports = [
    ../linux/configuration.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "stommydx";

  # resolv.conf is managed by WSL (wsl.wslConf.network.generateResolvConf)
  services.resolved.enable = lib.mkForce false;
}
