{
  config,
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

  # temporary local configuration as global config is not available
  stylix = {
    image = config.lib.stylix.pixel "base02";
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
