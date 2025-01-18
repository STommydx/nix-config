{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    android-tools
    scrcpy
  ];

  homebrew = {
    casks = [
      "flutter"
    ];
  };

}
