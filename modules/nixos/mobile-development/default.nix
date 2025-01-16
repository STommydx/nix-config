{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    scrcpy
  ];

  programs.adb.enable = true;

}
