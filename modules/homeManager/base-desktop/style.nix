{ pkgs, ... }:

{
  # TODO: intellegently import stylix only on home manager only configurations
  # imports = [
  #   inputs.stylix.homeManagerModules.stylix
  # ];

  stylix = {
    enable = true;
    fonts = {
      serif = {
        name = "Source Serif 4";
        package = pkgs.source-serif;
      };
      sansSerif = {
        name = "Source Sans 3";
        package = pkgs.source-sans;
      };
      monospace = {
        name = "MesloLGM Nerd Font";
        package = pkgs.nerd-fonts.meslo-lg;
      };
    };

    # Disable stylix for apps that already have tokyo night theme
    targets.firefox.enable = false;
    targets.ghostty.enable = false;
    targets.vscode.enable = false;
    targets.nixvim.enable = false;
  };
}
