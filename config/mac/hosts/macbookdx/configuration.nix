{ pkgs, ... }: {

  imports = [
    ../../configuration.nix
  ];

  networking.hostName = "macbookdx";

  environment.systemPackages = with pkgs; [
    cfssl
    consul
    consul-template
    grpcurl
    goreleaser
    minio-client
    nomad
    packer
    qpdf
    scrcpy
    temporal-cli
    vault
    wander
  ];

  homebrew = {
    brews = [
      "ory/tap/hydra"
      "ory/tap/kratos"
    ];
    casks = [
      "atomicjar/tap/testcontainers-desktop"
      "flutter"
      "microsoft-edge"
      "osu"
      "zed"
    ];
    taps = [
      "atomicjar/tap"
      "ory/tap"
    ];
  };
}
