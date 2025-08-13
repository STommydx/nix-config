{ inputs, pkgs, ... }:

{

  imports = [
    ../../../profiles/darwin/alltheway-desktop
    ../../../systems/macbook
    inputs.home-manager.darwinModules.home-manager
  ];

  # Home Manager setting for host
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.stommydx = {
    imports = [
      ../../../profiles/homeManager/devops
    ];
  };
  home-manager.extraSpecialArgs = { inherit inputs; };

  homebrew = {
    masApps = {
      "Windows App" = 1295203466;
    };
  };

  # Machine specific package for development and other purposes
  environment.systemPackages = with pkgs; [
    fly
  ];

  networking.hostName = "macbookdx";

  system.primaryUser = "stommydx";
  users.users.stommydx = {
    # weird behaviour home-manager does not pick up home directory from hm config
    home = /Users/stommydx;
  };

}
