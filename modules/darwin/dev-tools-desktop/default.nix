{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
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
    ubuntu_font_family
    # Nerd Fonts for icons
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.ubuntu-sans
  ];

  homebrew = {
    casks = [
      "atomicjar/tap/testcontainers-desktop"
      "beekeeper-studio"
      "insomnia"
      "jetbrains-toolbox"
      "microsoft-edge" # extra chrome based browser for web development
      "orbstack"
      "visual-studio-code"
      "zed"
    ];
    taps = [
      "atomicjar/tap"
    ];
  };

}
