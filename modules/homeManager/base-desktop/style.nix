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
    targets.swaylock.enable = false; # https://github.com/danth/stylix/issues/843
    targets.qt.enable = false; # stylix does not support adwaita yet
    targets.zed.enable = false;
  };
}
