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
