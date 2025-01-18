{ inputs, pkgs, ... }:

{

  imports = [
    inputs.nix-index-database.darwinModules.nix-index
  ];

  environment.systemPackages = with pkgs; [
    age
    ansible
    ansible-lint
    cloudflared
    ctop
    deploy-rs # for deploying nixos configurations
    duf
    iperf # network speed testing
    minio-client
    neofetch # :D
    opentofu # Terraform witho shxt license
    rclone
    restic
    sops # managing secrets
    valkey # for valkey-cli to manage Redis and Valkey instances
  ];

  # Nix index for searching packages
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

}
