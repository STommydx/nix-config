{ config, pkgs, lib, ... }:

{
  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

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
      options = "--delete-older-than 30d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };

  programs.nix-index.enable = true;
  programs.tmux.enable = true;
  programs.zsh.enable = true;
}
