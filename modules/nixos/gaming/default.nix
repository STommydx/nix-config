{ config, pkgs, ... }:

{

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  environment.systemPackages = with pkgs; [
    discord
    goverlay
    heroic
    lm_sensors
    mangohud
    obs-studio
    osu-lazer-bin
    # oversteer
    piper
    prismlauncher
    protonup-qt
    virt-manager
    # yuzu-mainline
  ];

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  # Driving wheels
  # hardware.new-lg4ff.enable = true;

  hardware.steam-hardware.enable = true;

  # For XBox controllers
  hardware.xpadneo.enable = true;

  # Linux gaming optimizations
  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  services.ratbagd.enable = true; # for configuring gaming devices, use with piper

}
