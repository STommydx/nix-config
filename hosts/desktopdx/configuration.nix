{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  fileSystems = {
    "/data".options = [ "compress=zstd:1" ];
  };

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
    efi.canTouchEfiVariables = true;
  };
  boot.plymouth.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
  ];

  networking.hostName = "desktopdx";

  users.users.stommydx.extraGroups = [ "libvirtd" "vboxusers" ];

  virtualisation.libvirtd = {
    enable = true;
  };
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
}
