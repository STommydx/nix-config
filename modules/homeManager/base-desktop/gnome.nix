{ lib, pkgs, ... }:

with lib.hm.gvariant;

{

  # GNOME settings, configured with dconf
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [
        (mkTuple [
          "xkb"
          "us+colemak"
        ])
        (mkTuple [
          "xkb"
          "us"
        ])
        (mkTuple [
          "ibus"
          "table:jyutping"
        ])
        (mkTuple [
          "ibus"
          "mozc-jp"
        ])
      ];
    };
    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-weekday = true;
      # color-scheme = "prefer-dark";
      # cursor-theme = "breeze_cursors";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      # gtk-theme = "Adwaita";
      icon-theme = "Papirus-Dark";
    };
    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };
    "org/gnome/desktop/wm/keybindings" = {
      maximize = [ ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      move-to-workspace-5 = [ "<Shift><Super>5" ];
      move-to-workspace-6 = [ "<Shift><Super>6" ];
      move-to-workspace-7 = [ "<Shift><Super>7" ];
      move-to-workspace-8 = [ "<Shift><Super>8" ];
      move-to-workspace-9 = [ "<Shift><Super>9" ];
      move-to-workspace-10 = [ "<Shift><Super>0" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      switch-to-workspace-10 = [ "<Super>0" ];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize:appmenu";
      num-workspaces = 6;
    };
    "org/gnome/mutter" = {
      check-alive-timeout = mkUint32 30000;
      dynamic-workspaces = false;
    };
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ ];
      toggle-tiled-right = [ ];
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "arcmenu@arcmenu.com"
        "blur-my-shell@aunetx"
        "dash-to-dock@micxgx.gmail.com"
        "gsconnect@andyholmes.github.io"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "forge@jmmaranan.com"
      ];
      favorite-apps = [
        "firefox.desktop"
        "com.mitchellh.ghostty.desktop"
        "org.gnome.Nautilus.desktop"
        "org.telegram.desktop.desktop"
        "signal-desktop.desktop"
        "discord.desktop"
        "spotify.desktop"
      ];
    };
    "org/gnome/shell/extensions/arcmenu" = {
      arcmenu-hotkey = [ "<Shift>Super_L" ]; # prevent ArcMenu hotkey conflicting with GNOME overview
      distro-icon = 22; # NixOS icon
      menu-layout = "Redmond";
      menu-button-appearance = "Icon_Text";
      menu-button-icon = "Distro_Icon";
      show-activities-button = true; # for a nice workspace indicator in GNOME 45+
    };
    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = true;
      enable-all = false;
      whitelist = [ "com.mitchellh.ghostty" ];
    };
    "org/gnome/shell/extensions/forge" = {
      focus-border-toggle = false;
      preview-hint-enabled = true;
      tiling-mode-enabled = true;
      window-gap-hidden-on-single = true;
      window-gap-size = mkUint32 4;
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = false;
      click-action = "minimize-or-previews";
      custom-theme-shrink = false;
      dash-max-icon-size = 40;
      dock-position = "BOTTOM";
      intellihide-mode = "ALL_WINDOWS";
      running-indicator-dominant-color = true;
      running-indicator-style = "CILIORA";
      show-favorites = true;
      show-mounts = false;
      show-trash = false;
    };
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
      switch-to-application-10 = [ ];
    };
    "org/gnome/shell/weather" = {
      automatic-location = true;
      locations = "[<(uint32 2, <('Hong Kong', 'VHHH', true, [(0.38979019379430269, 1.9928751117510946)], [(0.38949931722116538, 1.9928751117510946)])>)>]";
    };
    "org/gnome/terminal/legacy/profiles:/:842ec37e-9d77-4e26-86c5-41fc3bca62c5" = {
      background-transparency-percent = 20;
      default-size-columns = 120;
      default-size-rows = 36;
      use-transparent-background = true;
    };
  };

  # Access clipboard from terminal
  # This is a wayland specific setting
  home.shellAliases = {
    pbcopy = "wl-copy";
    pbpaste = "wl-paste";
  };

  home.packages =
    with pkgs;
    # GNOME extensions installed in user environment
    (with gnomeExtensions; [
      appindicator
      arcmenu
      blur-my-shell
      dash-to-dock
      forge
      gsconnect
    ]) ++ [
      papirus-icon-theme # install icon theme as it might not be installed globally
    ];

  # GNOME Terminal configuration
  # deprecated in favor of ghostty
  programs.gnome-terminal = {
    enable = true;
    profile."842ec37e-9d77-4e26-86c5-41fc3bca62c5" = {
      default = true;
      visibleName = "Default";
      # transparencyPercent = 20; # this option does not work with colors = null
    };
  };

  # Adwaita theming for Qt applications
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  # Enable GNOME keyring integration
  services.gnome-keyring.enable = true;

}
