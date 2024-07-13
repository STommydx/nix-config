{ config, pkgs, lib, ... }:

{
  wsl.defaultUser = "stommydx";

  networking.hostName = "winpcdx";

  # resolv.conf is managed by WSL (wsl.wslConf.network.generateResolvConf)
  services.resolved.enable = lib.mkForce false;
}
