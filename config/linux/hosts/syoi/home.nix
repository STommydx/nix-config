{ config, pkgs, lib, ... }:

{
  imports = [
    ../../home.nix
  ];
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "syoi.github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/id_syoi";
      };
    };
  };
}
