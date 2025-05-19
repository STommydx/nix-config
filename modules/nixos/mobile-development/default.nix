{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    android-studio
    flutter
    scrcpy
  ];

  programs.adb.enable = true;

}
