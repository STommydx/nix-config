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
    gnupg
    go
    gping
    gh
    iperf
    lazygit
    lolcat
    neofetch
    nodejs
    nodePackages.pnpm
    nomad
    packer
    pandoc
    pipenv
    pre-commit
    protobuf
    (python3.withPackages (pythonPkgs: with pythonPkgs; [
      ipython
      pandas
    ]))
    restic
    rustc
    tealdeer # tldr in Rust, respect XDG specs
    terraform
    vault
    wander
    xh
    yt-dlp
    yq
  ];

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
