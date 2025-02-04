{ lib, ... }:

{

  imports = [ ../../../profiles/homeManager/devops ];

  home.username = lib.mkForce "thomasli";
  home.homeDirectory = lib.mkForce "/homes/thomasli";

}
