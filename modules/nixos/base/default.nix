{ pkgs, ... }:

{

  imports = [
    ./networking.nix
    ./secrets.nix
  ];

  # console settings
  console = {
    keyMap = "colemak";
  };

  # utility packages for every system
  environment.systemPackages = with pkgs; [
    btop # process monitor
    dig # for debugging DNS
    file # file information command
    gnupg # for signing and decryption
    jq # for running scripts on JSON data
    netcat # debugging network connections
    p7zip # unzip archives
    tealdeer # tldr in Rust, respect XDG specs
    wget # file download utility
  ];

  # Allow proprietary packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    # Nix options for reducing storage spaces
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      # This may cause random build failures but solvable upon retry. See https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = true;
      # Enable flakes by default
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # allow remote builds for admins
      trusted-users = [
        "@wheel"
      ];
    };
  };

  programs._1password.enable = true;

  # for cloning configurations from git repository
  programs.git.enable = true;

  # for installing packages with dynamically linked libraries, such as VSCode
  # server
  programs.nix-ld.enable = true;

  # nvim as defualt editor for all users
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # to run commands in an unstable ssh session
  programs.tmux.enable = true;

  # ZSH Options
  programs.zsh = {
    enable = true;
    # install commonly used plugins
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # BTRFS file maintenance
  services.btrfs.autoScrub.enable = true;

  # enable SSH service for remote access
  services.openssh.enable = true;

  # use ZSH as default shell for all users
  users.defaultUserShell = pkgs.zsh;

  # enable zram as swap
  # refer to RFC on Fedora for details:
  # https://fedoraproject.org/wiki/Changes/SwapOnZRAM
  zramSwap.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
