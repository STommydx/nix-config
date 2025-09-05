{ inputs, ... }:

{

  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];

  # Nix index for searching packages
  programs.command-not-found.enable = false; # use nix-index instead
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

}
