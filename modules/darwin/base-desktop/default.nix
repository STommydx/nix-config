{ pkgs, ... }:

{

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
  ];

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
    casks = [
      "1password" # password manager
      "adobe-acrobat-reader" # pdf reader
      "firefox" # web browser
      "ghostty" # terminal for command line access
      "jordanbaird-ice" # hidden tray icons
      "keka" # zip utility
      "macfuse" # user level file system mounting
      "maccy" # clipboard manager
      "rectangle" # window tiling manager
      "stats" # system info in system tray
      "unnaturalscrollwheels" # mouse scroll wheel configurator
      "vial" # keyboard configuration software
      "vlc" # video player
    ];
    masApps = {
      "Tailscale" = 1475387142;
      "WireGuard" = 1451685025;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults = {
    NSGlobalDomain.InitialKeyRepeat = 25;
    NSGlobalDomain.KeyRepeat = 2;
    dock.autohide = true;
    dock.tilesize = 48;
    screencapture.location = "~/Desktop/Screenshot";
  };

  # set timezone for desktop
  time.timeZone = "Asia/Hong_Kong";

}
