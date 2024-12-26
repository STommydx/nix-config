{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../configuration.nix
    ];

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      # efiInstallAsRemovable = true; # install as removable for easy recovery after windows overwriting bootloader
      useOSProber = true;
    };
    efi.canTouchEfiVariables = true;
  };
  boot.plymouth.enable = true;
  boot.supportedFilesystems = [ "ntfs" ]; # enable ntfs support for windows partition mounting

  environment.systemPackages = with pkgs; [
    heroic
    mangohud
    osu-lazer-bin
    # oversteer
    piper
    prismlauncher
    protonup-qt
    virt-manager
    # yuzu-mainline
  ];

  # nixos-generate-config doesn't detect mount options automatically
  fileSystems = {
    "/".options = [ "compress=zstd:1" ];
    "/home".options = [ "compress=zstd:1" ];
    "/nix".options = [ "compress=zstd:1" "noatime" ];
    "/data".options = [ "compress=zstd:1" ];
  };

  hardware.cpu.amd.updateMicrocode = true;
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
  # hardware.new-lg4ff.enable = true;
  hardware.steam-hardware.enable = true;
  hardware.xpadneo.enable = true;

  networking.hostName = "desktopdx";

  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  services.btrfs.autoScrub.enable = true;
  services.ratbagd.enable = true; # for configuring gaming devices, use with piper
  services.restic.backups = {
    datastore = {
      environmentFile = config.sops.secrets.minio_credentials.path;
      passwordFile = config.sops.secrets.restic_password.path;
      paths = [
        "/data/datastore"
      ];
      pruneOpts = [
        "--keep-within 30d"
      ];
      repository = "s3:https://artifacts.stdx.space/restic";
      timerConfig = {
        OnCalendar = "Mon,Wed,Sat";
        Persistent = true;
      };
    };
    home = {
      environmentFile = config.sops.secrets.minio_credentials.path;
      passwordFile = config.sops.secrets.restic_password.path;
      paths = [
        "/home/stommydx/Documents"
        "/home/stommydx/Downloads"
        "/home/stommydx/Pictures"
        "/home/stommydx/Videos"
        "/home/stommydx/workspace"
      ];
      pruneOpts = [
        "--keep-within 30d"
      ];
      repository = "s3:https://artifacts.stdx.space/restic";
      timerConfig = {
        OnCalendar = "Mon,Wed,Sat";
        Persistent = true;
      };
    };
  };

  # Add rule for using rocm in deep learning libraries
  # https://nixos.wiki/wiki/AMD_GPU
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  users.users.stommydx.extraGroups = [ "libvirtd" "vboxusers" ];

  virtualisation.docker = {
    storageDriver = "btrfs";
  };
  virtualisation.libvirtd = {
    enable = true;
  };
}
