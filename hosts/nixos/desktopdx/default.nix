{ inputs, pkgs, ... }:

{

  imports = [
    ../../../profiles/nixos/alltheway-desktop
    ../../../systems/baremetal-amd
    ../../../users/stommydx
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ./backup.nix
  ];

  # Home Manager setting for host
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.stommydx = {
    imports = [
      ../../../profiles/homeManager/alltheway-desktop
    ];
  };
  # Special thanks to random guy on reddit!
  # https://www.reddit.com/r/NixOS/comments/1bqzg78/pass_specialargs_into_extraspecialargs_when_using/
  home-manager.extraSpecialArgs = { inherit inputs; };

  boot.plymouth.enable = true;
  boot.supportedFilesystems = [ "ntfs" ]; # enable ntfs support for windows partition mounting

  # Some random tools/programs, not sure which module they belong to...
  environment.systemPackages = with pkgs; [
    remmina
    transmission_4-gtk
    usbutils
    ventoy
  ];

  # nixos-generate-config doesn't detect mount options automatically
  # TODO: replace this with disko configuration
  fileSystems = {
    "/".options = [ "compress=zstd:1" ];
    "/home".options = [ "compress=zstd:1" ];
    "/nix".options = [
      "compress=zstd:1"
      "noatime"
    ];
    "/data".options = [ "compress=zstd:1" ];
  };

  networking.hostName = "desktopdx";

  users.users.stommydx.extraGroups = [
    "docker"
    "libvirtd"
  ];

}
