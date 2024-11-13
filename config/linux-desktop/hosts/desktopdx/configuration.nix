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
    blender
    virt-manager
  ];

  # nixos-generate-config doesn't detect mount options automatically
  fileSystems = {
    "/".options = [ "compress=zstd:1" ];
    "/home".options = [ "compress=zstd:1" ];
    "/nix".options = [ "compress=zstd:1" "noatime" ];
    "/data".options = [ "compress=zstd:1" ];
  };

  hardware.cpu.amd.updateMicrocode = true;

  networking.hostName = "desktopdx";

  services.btrfs.autoScrub.enable = true;
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

  # allow for outdated electron used in heroic
  nixpkgs.config.permittedInsecurePackages = [
    "electron-24.8.6"
  ];
}
