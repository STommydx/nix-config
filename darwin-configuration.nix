{ config, pkgs, ... }:

{

  users.users.stommydx = {
    home = "/Users/stommydx";
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # minimal package set
    age
    ansible
    btop
    dig
    file
    git
    gnumake
    jq
    neovim
    netcat
    p7zip
    rclone
    sops
    sshfs
    tree
    unzip
    wget
    zip
  ] ++ [
    # standard package set
    ansible-lint
    bat
    black
    cargo
    cfssl
    cloudflared
    cmake
    consul
    consul-template
    ctop
    dasel
    delta
    duf
    exa
    ffmpeg
    gcc
    gping
    gh
    httpie
    iperf
    lazygit
    lolcat
    neofetch
    nomad
    packer
    pandoc
    protobuf
    (python3.withPackages (pythonPkgs: with pythonPkgs; [
      ipython
      pandas
    ]))
    rustc
    terraform
    tldr
    vault
    wander
    youtube-dl
  ] ++ [
    # desktop package set
    iterm2
    mpv
    pam_u2f
    vscode
  ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "DroidSansMono"
        "JetBrainsMono"
        "Meslo"
        "SourceCodePro"
        "Ubuntu"
      ];
    })
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    ubuntu_font_family
  ];

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    casks = [
      "1password"
      "discord"
      "firefox"
      "hiddenbar"
      "keka"
      "logi-options-plus"
      "moonlight"
      "obs"
      "postman"
      "rectangle"
      "signal"
      "slack"
      "stats"
      "steam"
      "tailscale"
      "telegram"
      "utm"
      "via"
      "vial"
      "vlc"
      "whatsapp"
    ];
    taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nix-index.enable = true;
  programs.tmux = {
    enable = true;
    iTerm2 = true;
  };
  programs.vim.enable = true;
  programs.zsh = {
    enable = true;
    enableFzfCompletion = true;
    enableFzfHistory = true;
  };

  security.pam.enableSudoTouchIdAuth = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

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

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
