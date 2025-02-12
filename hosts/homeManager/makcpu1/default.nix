{ lib, ... }:

{

  imports = [ ../../../profiles/homeManager/devops ];

  home.username = lib.mkForce "thomasli";
  home.homeDirectory = lib.mkForce "/homes/thomasli";

  programs.zsh.initExtra = ''
    eval "$(/2tssd/thomasli/miniconda3/bin/conda shell.bash hook)"
  '';

  xdg.cacheHome = lib.mkForce "/2tssd/thomasli/home/.cache";
  xdg.dataHome = lib.mkForce "/2tssd/thomasli/home/.local/share";
  xdg.stateHome = lib.mkForce "/2tssd/thomasli/home/.local/state";

}
