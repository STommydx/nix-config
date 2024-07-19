{ pkgs, ... }: {

  imports = [
    ../shared/configuration.nix
  ];

  users.users.stommydx = {
    home = "/Users/stommydx";
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = with pkgs; [
    _1password
    jdk
    mas
    mosh
    unixtools.watch
    yubikey-manager
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # MacOS Specific Configurations
  security.pam.enableSudoTouchIdAuth = true;
  system.defaults = {
    CustomUserPreferences = { };
    NSGlobalDomain.InitialKeyRepeat = 25;
    NSGlobalDomain.KeyRepeat = 2;
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    dock.autohide = true;
    dock.tilesize = 48;
    screencapture.location = "~/Desktop/Screenshot";
    trackpad.Clicking = true;
    trackpad.TrackpadThreeFingerDrag = true;
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
    casks = [
      "1password"
      "adobe-acrobat-reader"
      "blackhole-16ch"
      "discord"
      "docker"
      "firefox"
      "insomnia"
      "iterm2"
      "keka"
      "macfuse"
      "microsoft-remote-desktop"
      "rectangle"
      "signal"
      "spotify"
      "stats"
      "steam"
      "telegram"
      "unnaturalscrollwheels"
      "vial"
      "visual-studio-code"
      "vlc"
      "xournal-plus-plus"
      "yubico-yubikey-manager"
      "zoom"
    ];
    masApps = {
      "Hidden Bar" = 1452453066;
      "Tailscale" = 1475387142;
      "WireGuard" = 1451685025;
      "WhatsApp Messenger" = 310633997;
    };
  };

  nix = {
    gc = {
      interval = [
        {
          Hour = 0;
          Minute = 0;
          Weekday = 7;
        }
      ];
    };
  };
}
