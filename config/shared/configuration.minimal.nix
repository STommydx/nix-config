{ config, pkgs, lib, ... }:

{
  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
      "zh_HK.UTF-8/UTF-8"
    ];
  };
  console = { keyMap = "colemak"; };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    age
    ansible
    btop
    dig
    file
    gnumake
    jq
    netcat
    p7zip
    python3
    rclone
    sops
    sshfs
    tree
    unzip
    wget
    zip
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };

  programs.command-not-found.enable = false; # use nix-index instead
  programs.git.enable = true;
  programs.iotop.enable = true;
  programs.nix-index.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
  };
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh.enable = true;
    autosuggestions.enable = true;
  };

  # Enable nix-ld
  # For running unpatched binaries such as VS Code remote SSH plugin server
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

  services.resolved = {
    enable = true;
    extraConfig = "MulticastDNS=yes";
  };
  services.openssh.enable = true;
  services.qemuGuest.enable = true;
  services.tailscale.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
