{ config, pkgs, lib, ... }:

{
  imports = [
    ./configuration.minimal.nix
    ../shared/configuration.nix
  ];

  users.users.stommydx = {
    isNormalUser = true;
    extraGroups = [ "wheel" "storage" "docker" "networkmanager" ];
    hashedPasswordFile = config.sops.secrets.password.path;
  };
  users.groups.storage = { };

  environment.systemPackages = with pkgs; [
    gdb
    trickle
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
  # temporarily disable thefuck before fix merged to unstable
  # https://github.com/NixOS/nixpkgs/pull/325875
  programs.thefuck.enable = false;

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

  # temporary workaround for https://github.com/NixOS/nixpkgs/issues/180175
  # NetworkManager-wait-online.service fails system activation if enabled
  systemd.services.NetworkManager-wait-online.enable = false;

  virtualisation.docker = {
    enable = true;
  };

  zramSwap.enable = true;

}
