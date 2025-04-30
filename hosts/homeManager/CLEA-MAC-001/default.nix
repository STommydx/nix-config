{
  inputs,
  lib,
  pkgs,
  ...
}:

{

  imports = [
    ../../../profiles/homeManager/devops
  ];

  home.username = lib.mkForce "thomasli";
  home.homeDirectory = lib.mkForce "/Users/thomasli";

  home.packages = with pkgs; [ ];

  # TODO: Move this to appropriate place
  nixpkgs.config.allowUnfree = true;

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "dev.clea.internal" = {
        hostname = "10.11.3.22";
        user = "system";
      };
    };
  };

  programs.zed-editor = {
    userSettings = {
      ssh_connections = [
        {
          host = "dev.clea.internal";
        }
        {
          host = "makcpu1.cse.ust.hk";
        }
      ];
    };
  };

}
