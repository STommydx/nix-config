{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    beekeeper-studio
    google-chrome # extra chrome based browser for web development
    insomnia
    jetbrains-toolbox
    vscode
    zed-editor # text editor and IDE
  ];

  fonts.packages = with pkgs; [
    # Extra monospace fonts
    fira
    meslo-lg
    open-sans
    source-sans
    source-serif
    roboto
    ubuntu-classic
    # Nerd Fonts for icons
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.ubuntu-sans
  ];

  # Temporarily allow the current Nixpkgs Beekeeper Studio release despite its EOL Electron.
  nixpkgs.config.permittedInsecurePackages = [
    "beekeeper-studio-6.1.4"
  ];

}
