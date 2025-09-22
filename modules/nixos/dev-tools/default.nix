{ pkgs, ... }:

{

  imports = [
    ./vibe.nix
  ];

  environment.systemPackages = with pkgs; [
    bat # cat alternative, colorize code outputs
    black # Python code formatter
    cargo
    clang-tools
    cmake
    ctop
    gcc
    gdb
    gh # GitHub CLI
    gnumake
    go
    grpcurl # like curl, but for gRPC
    just # command runner, like make
    lazygit # TUI for git
    nodejs
    nodePackages.pnpm
    pipx
    pre-commit
    protobuf
    (python3.withPackages (
      pythonPkgs: with pythonPkgs; [
        ipython
        pandas
      ]
    ))
    rustc
    treefmt
    xh # command line HTTP client, easier to use than curl
  ];

  programs.java.enable = true;
  programs.npm.enable = true;
  programs.starship.enable = true; # shell prompt

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

}
