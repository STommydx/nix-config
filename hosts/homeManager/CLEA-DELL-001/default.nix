{
  inputs,
  lib,
  pkgs,
  ...
}:

{

  imports = [
    ../../../profiles/homeManager/devops-desktop
    inputs.stylix.homeManagerModules.stylix
  ];

  home.username = lib.mkForce "thomasli";
  home.homeDirectory = lib.mkForce "/home/thomasli";

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
      ];
    };
  };

  # temporary local configuration as global config is not available
  stylix = {
    image = ./assets/clea-wallpaper-4k-dark.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
    polarity = "dark";
    cursor = {
      package = pkgs.kdePackages.breeze;
      name = "breeze_cursors";
      size = 24;
    };
    fonts.sizes = {
      applications = 11;
      terminal = 11;
    };
  };

}
