{ pkgs, ... }:

{
  # TODO: intellegently import stylix only on home manager only configurations
  # imports = [
  #   inputs.stylix.homeManagerModules.stylix
  # ];

  stylix = {
    enable = true;
    image = ./assets/tokyo-night-programmer.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
    polarity = "dark";
    cursor = {
      package = pkgs.kdePackages.breeze;
      name = "breeze_cursors";
      size = 24;
    };
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
      sizes = {
        applications = 11;
        terminal = 11;
      };
    };

    opacity = {
      terminal = 0.8;
    };

    # Disable stylix for apps that already have tokyo night theme
    targets.firefox.enable = false;
    targets.ghostty.enable = false;
    targets.vscode.enable = false;
    targets.nixvim.enable = false;
  };
}
