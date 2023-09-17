{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  fileSystems = {
    "/data".options = [ "compress=zstd:1" ];
  };

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
    efi.canTouchEfiVariables = true;
  };
  boot.plymouth.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
  ];

  networking.hostName = "desktopdx";

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

  users.users.stommydx.extraGroups = [ "libvirtd" "vboxusers" ];

  virtualisation.libvirtd = {
    enable = true;
  };
}
