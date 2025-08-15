{
  lib,
  ...
}:

{

  imports = [
    ../../../profiles/homeManager/devops
    ../../../modules/homeManager/dev-tools-desktop/zed.nix
  ];

  home.username = lib.mkForce "thomasli";
  home.homeDirectory = lib.mkForce "/Users/thomasli";

  # TODO: Move this to appropriate place
  nixpkgs.config.allowUnfree = true;

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "dev.clea.internal" = {
        hostname = "100.98.47.75";
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
