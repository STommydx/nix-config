{ config, pkgs, lib, ... }:

{

  imports = [ ./configuration.nix ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  hardware.bluetooth.enable = true;
  hardware.xpadneo.enable = true;
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
  hardware.new-lg4ff.enable = true;
  hardware.pulseaudio.enable = false; # prevent pipewire conficting pulseaudio
  hardware.steam-hardware.enable = true;

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      # mozc disabled due to https://github.com/NixOS/nixpkgs/pull/281674
      table
      table-chinese
    ];
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-console
  ];
  environment.systemPackages = with pkgs; [
    alacritty
    anki
    appimage-run
    bottles
    dconf2nix
    discord
    element-desktop
    firefox
    gnome.gnome-tweaks
    google-chrome
    goverlay
    heroic
    insomnia
    jetbrains-toolbox
    libreoffice
    lm_sensors
    mangohud
    moonlight-qt
    mpv
    obs-studio
    osu-lazer-bin
    oversteer
    pam_u2f
    papirus-icon-theme
    pinta
    piper
    prismlauncher
    # postman temp disabled due to https://github.com/NixOS/nixpkgs/issues/259147
    remmina
    scrcpy
    signal-desktop
    solaar
    spotify
    tdesktop
    transmission-gtk
    usbutils
    ventoy
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

  fonts = {
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "Noto Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "DroidSansMono"
          "JetBrainsMono"
          "Meslo"
          "Noto"
          "SourceCodePro"
          "Ubuntu"
        ];
      })
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      ubuntu_font_family
    ];
  };

  nixpkgs.overlays = [
    (import ./overlays/gnome-terminal-transparency.nix)
    (import ./overlays/solaar-systray.nix)
  ];

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
  services.fprintd.enable = true;
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
  services.ratbagd.enable = true;
  services.saned.enable = true;
  services.udisks2.enable = true;
  services.udev.packages = with pkgs; [ vial ];
  services.xserver = {
    enable = true;
    xkb.variant = "colemak";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # temporary workaround for https://github.com/NixOS/nixpkgs/issues/180175
  # NetworkManager-wait-online.service fails system activation if enabled
  systemd.services.NetworkManager-wait-online.enable = false;

  xdg.portal.enable = true;
}
