{ inputs, ... }:

{

  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  # use precompiled nix-index database
  programs.nix-index-database.comma.enable = true;

}
