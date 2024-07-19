{ config, pkgs, lib, ... }:

{

  imports = [ ./configuration.minimal.nix ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stommydx = {
    packages = with pkgs; [ nixpkgs-fmt ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    ansible-lint
    bat
    black
    cargo
    cfssl
    clang-tools
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
    go
    gping
    gh
    iperf
    lazygit
    lolcat
    neofetch
    nomad
    packer
    pandoc
    pre-commit
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
    xh
    yt-dlp
    yq
  ];

}
