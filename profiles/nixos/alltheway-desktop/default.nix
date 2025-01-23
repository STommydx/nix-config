{ ... }:

{

  imports = [
    ../../../modules/nixos/base
    ../../../modules/nixos/base-desktop
    ../../../modules/nixos/dev-tools
    ../../../modules/nixos/dev-tools-desktop
    ../../../modules/nixos/gaming
    # ../../../modules/nixos/machine-learning # RIP: https://github.com/NixOS/nixpkgs/issues/375745
    ../../../modules/nixos/mobile-development
    ../../../modules/nixos/multimedia
    ../../../modules/nixos/office-tools
    ../../../modules/nixos/ops-tools
    ../../../modules/nixos/virtualization
  ];

}
