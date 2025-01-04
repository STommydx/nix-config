{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../configuration.nix
  ];

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
    cfssl
    consul
    grpcurl
    goreleaser
    microsoft-edge
    minio-client
    nomad
    qpdf
    temporal-cli
    vault
    wander
  ];

  # nixos-generate-config doesn't detect mount options automatically
  fileSystems = {
    "/".options = [ "compress=zstd:1" ];
    "/home".options = [ "compress=zstd:1" ];
    "/nix".options = [
      "compress=zstd:1"
      "noatime"
    ];
  };

  hardware.cpu.intel.updateMicrocode = true;

  networking.hostName = "workpcdx";

  services.btrfs.autoScrub.enable = true;
  services.restic.backups = { };

  # Add rule for using rocm in deep learning libraries
  # https://nixos.wiki/wiki/AMD_GPU
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  users.users.stommydx.extraGroups = [
  ];

  virtualisation.docker = {
    storageDriver = "btrfs";
  };
}
