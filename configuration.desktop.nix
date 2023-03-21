{ config, pkgs, lib, ... }:

{

  imports = [ ./configuration.nix ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  hardware.bluetooth.enable = true;
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
  hardware.pulseaudio.enable = false; # prevent pipewire conficting pulseaudio
  hardware.steam-hardware.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-console
  ];
  environment.systemPackages = with pkgs; [
    alacritty
    appimage-run
    bottles
    discord
    firefox
    gnome.gnome-tweaks
    goverlay
    heroic
    jetbrains-toolbox
    mangohud
    moonlight-qt
    mpv
    obs-studio
    pam_u2f
    papirus-icon-theme
    pinta
    prismlauncher
    postman
    remmina
    signal-desktop
    slack
    solaar
    spotify
    tdesktop
    transmission
    usbutils
    ventoy-bin
    via
    vial
    vlc
    vscode
    whatsapp-for-linux
    wl-clipboard
    xournalpp
    yubikey-manager
    yuzu-mainline
    zoom
  ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "DroidSansMono"
        "JetBrainsMono"
        "Meslo"
        "SourceCodePro"
        "Ubuntu"
      ];
    })
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    ubuntu_font_family
  ];

  nixpkgs.overlays = [ (import ./overlays/gnome-terminal-transparency.nix) ];

  programs._1password-gui.enable = true;
  programs.adb.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  programs.gamemode.enable = true;
  programs.gnome-terminal.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  security.pam.u2f = {
    enable = true;
    control = "sufficient";
    cue = true;
    appId = "pam://auth.stdx.space";
    origin = "pam://auth.stdx.space";
  };
  security.polkit.extraConfig = ''
    // mounting without password for `storage` group
    polkit.addRule(function(action, subject) {
      var YES = polkit.Result.YES;
      var permission = {
        "org.freedesktop.udisks.filesystem-mount": YES,
        "org.freedesktop.udisks.luks-unlock": YES,
        "org.freedesktop.udisks.drive-eject": YES,
        "org.freedesktop.udisks.drive-detach": YES,
        "org.freedesktop.udisks2.filesystem-mount": YES,
        "org.freedesktop.udisks2.encrypted-unlock": YES,
        "org.freedesktop.udisks2.eject-media": YES,
        "org.freedesktop.udisks2.power-off-drive": YES,
        "org.freedesktop.udisks2.filesystem-mount-system": YES,
        "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
        "org.freedesktop.udisks2.filesystem-unmount-others": YES,
        "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
        "org.freedesktop.udisks2.eject-media-other-seat": YES,
        "org.freedesktop.udisks2.power-off-drive-other-seat": YES
      };
      if (subject.isInGroup("storage")) {
        return permission[action.id];
      }
    });
  '';

  services.dbus.packages = [ pkgs.gcr ]; # for gpg agent setup with gnome
  services.flatpak.enable = true;
  services.gnome.gnome-browser-connector.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  services.printing.enable = true;
  services.saned.enable = true;
  services.udisks2.enable = true;
  services.xserver = {
    enable = true;
    xkbVariant = "colemak";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # temporary workaround for https://github.com/NixOS/nixpkgs/issues/180175
  # NetworkManager-wait-online.service fails system activation if enabled
  systemd.services.NetworkManager-wait-online.enable = false;

  xdg.portal.enable = true;
}
