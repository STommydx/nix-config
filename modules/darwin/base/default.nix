{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    _1password-cli # password manager
    btop # process monitor
    dig # for debugging DNS
    file # file information command
    gnupg # for signing and decryption
    jq # for running scripts on JSON data
    mas # CLI for install and manage Mac App Store apps
    netcat # debugging network connections
    p7zip # unzip archives
    tealdeer # tldr in Rust, respect XDG specs
    unixtools.watch
    wget # file download utility
  ];

  # Allow proprietary packages
  nixpkgs.config.allowUnfree = true;

  # Enable Homebrew
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
  };

  # Auto upgrade nix package and the daemon service.
  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
      interval = [
        {
          Hour = 0;
          Minute = 0;
          Weekday = 7;
        }
      ];
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    optimise.automatic = true;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # to run commands in an unstable ssh session
  programs.tmux.enable = true;

  programs.zsh.enable = true;

  system.defaults = {
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

}
