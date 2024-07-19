{ pkgs, ... }: {

  imports = [
    ../../configuration.nix
  ];

  networking.hostName = "macbookdx";

  environment.systemPackages = with pkgs; [
    grpcurl
    goreleaser
    minio-client
    qpdf
    scrcpy
    temporal-cli
  ];

  homebrew = {
    brews = [
      "ory/tap/hydra"
      "ory/tap/kratos"
    ];
    casks = [
      "flutter"
      "microsoft-edge"
      "osu"
      "zed"
    ];
    taps = [
      "ory/tap"
    ];
  };
}
