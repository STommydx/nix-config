{ config, pkgs, lib, ... }:

{

  imports = [ ./configuration.minimal.nix ];

  # nixos-generate-config doesn't detect mount options automatically
  fileSystems = {
    "/".options = [ "compress=zstd:1" ];
    "/home".options = [ "compress=zstd:1" ];
    "/nix".options = [ "compress=zstd:1" "noatime" ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stommydx = {
    isNormalUser = true;
    extraGroups = [ "wheel" "storage" "docker" "networkmanager" ];
    packages = with pkgs; [ nixpkgs-fmt ];
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.password.path;
  };
  users.groups.storage = { };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
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
    eza
    ffmpeg
    gcc
    gdb
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
    restic
    rustc
    terraform
    tldr
    vault
    wander
    youtube-dl
  ];

  networking.firewall.enable = false;
  networking.networkmanager = {
    enable = true;
    connectionConfig = {
      "connection.mdns" = 2;
    };
  };

  programs._1password.enable = true;
  programs.java.enable = true;
  programs.mosh.enable = true;
  programs.npm.enable = true;
  programs.thefuck.enable = true;

  services.btrfs.autoScrub.enable = true;

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age = {
      sshKeyPaths = [ ]; # prevent import error during first install
      keyFile = "/etc/sops-nix/key.txt";
      generateKey = true;
    };
    gnupg.sshKeyPaths = [ ]; # prevent import error during first install
    secrets = {
      password = {
        neededForUsers = true;
      };
      minio_credentials = { };
      restic_password = { };
    };
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  zramSwap.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
