{ config, pkgs, lib, ... }:

{

  imports = [ ../linux/configuration.nix ];

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
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      mozc
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
    gnome-tweaks
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
    transmission_4-gtk
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
    # yuzu-mainline
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
    settings = {
      cue = true;
      appId = "pam://auth.stdx.space";
      origin = "pam://auth.stdx.space";
    };
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

  stylix = {
    enable = true;
    image = ./assets/tokyo-night-programmer.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    polarity = "dark";
    cursor = {
      package = pkgs.kdePackages.breeze;
      name = "breeze_cursors";
      size = 24;
    };
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = pkgs.noto-fonts;
        name = "Noto Sans Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 11;
        terminal = 11;
      };
    };
  };

  services.dbus.packages = [ pkgs.gcr ]; # for gpg agent setup with gnome
  # services.fprintd.enable = true; # temporarily disabled due to build failure
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

  xdg.portal.enable = true;
}
