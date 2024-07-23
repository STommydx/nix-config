{ config, pkgs, lib, ... }:

{
  imports = [
    ../../configuration.minimal.nix
    ../../../shared/configuration.minimal.nix # note that linux minimal does not import shared
  ];

  users.users.root = {
    shell = pkgs.zsh;
  };
  users.users.stommydx = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  # disable systemd-resolved as resolv.conf is managed by lxc host
  # services.resolved.enable = lib.mkForce false;

  # disable boot loader (for obvious reasons)
  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.systemd-boot.enable = lib.mkForce false;

  services.adguardhome = {
    enable = true;
  };
  services.caddy = {
    enable = true;
  };
}
