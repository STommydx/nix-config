{ pkgs, lib, ... }: {

  imports = [
    ../shared/configuration.nix
  ];

  users.users.stommydx = {
    home = "/Users/stommydx";
    # shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = with pkgs; [
    _1password
    docker-client
    jdk
    mas
    mosh
    unixtools.watch
    yubikey-manager
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    gc = {
      interval = [
        {
          Hour = 0;
          Minute = 0;
          Weekday = 7;
        }
      ];
    };
    settings.auto-optimise-store = lib.mkForce false;
    optimise.automatic = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  fonts.packages = with pkgs; [
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.noto
    nerd-fonts.ubuntu-sans
    nerd-fonts.zed-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    ubuntu_font_family
  ];

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
    casks = [
      "1password"
      "adobe-acrobat-reader"
      "blackhole-16ch"
      "discord"
      "firefox"
      "insomnia"
      "iterm2"
      "jordanbaird-ice"
      "keka"
      "macfuse"
      "maccy"
      "orbstack"
      "rectangle"
      "signal"
      "spotify"
      "stats"
      "steam"
      "telegram"
      "transmission"
      "unnaturalscrollwheels"
      "vial"
      "visual-studio-code"
      "vlc"
      "xournal++"
      "yubico-yubikey-manager"
      "zoom"
    ];
    masApps = {
      # "Hidden Bar" = 1452453066;
      "Tailscale" = 1475387142;
      "WireGuard" = 1451685025;
      "WhatsApp Messenger" = 310633997;
      "Windows App" = 1295203466;
    };
  };

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

}
