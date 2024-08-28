{ pkgs, ... }: {

  imports = [
    ../../configuration.nix
  ];

  networking.hostName = "macbookdx";

  environment.systemPackages = with pkgs; [
    cfssl
    grpcurl
    goreleaser
    minio-client
    qpdf
    scrcpy
    temporal-cli
    wander
  ];

  homebrew = {
    brews = [
      "hashicorp/tap/consul"
      "hashicorp/tap/consul-template"
      "hashicorp/tap/nomad"
      "hashicorp/tap/packer"
      "hashicorp/tap/vault"
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
      "hashicorp/tap"
      "ory/tap"
    ];
  };
}
