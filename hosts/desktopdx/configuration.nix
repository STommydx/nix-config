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

  networking.hostName = "desktopdx";
}
