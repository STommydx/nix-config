{ pkgs, ... }: {

  imports = [
    ../../configuration.nix
  ];

  networking.hostName = "macbookdx";
}
