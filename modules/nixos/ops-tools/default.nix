{ inputs, pkgs, ... }:

{

  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  environment.systemPackages = with pkgs; [
    age
    ansible
    ansible-lint
    cloudflared
    ctop
    deploy-rs # for deploying nixos configurations
    duf
    gnupg
    iperf # network speed testing
    minio-client
    neofetch # :D
    opentofu # Terraform witho shxt license
    rclone
    restic
    sops # managing secrets
    valkey # for valkey-cli to manage Redis and Valkey instances
  ];

  programs.iotop.enable = true;

  # Nix index for searching packages
  programs.command-not-found.enable = false; # use nix-index instead
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

  virtualisation.docker.enable = true;

}
