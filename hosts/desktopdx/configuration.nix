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
      efiInstallAsRemovable = true; # install as removable for easy recovery after windows overwriting bootloader
      useOSProber = true;
    };
    # efi.canTouchEfiVariables = true;
  };
  boot.plymouth.enable = true;
  boot.supportedFilesystems = [ "ntfs" ]; # enable ntfs support for windows partition mounting

  environment.systemPackages = with pkgs; [
    virt-manager
  ];

  hardware.cpu.amd.updateMicrocode = true;

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

  # Add rule for using rocm in deep learning libraries
  # https://nixos.wiki/wiki/AMD_GPU
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # I hate this but I have to do it :C
  time.timeZone = lib.mkForce "America/Toronto";

  users.users.stommydx.extraGroups = [ "libvirtd" "vboxusers" ];

  virtualisation.libvirtd = {
    enable = true;
  };

  # allow for outdated electron used in heroic
  nixpkgs.config.permittedInsecurePackages = [
    "electron-24.8.6"
  ];
}
