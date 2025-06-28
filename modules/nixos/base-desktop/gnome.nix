{ pkgs, ... }:

{

  # exclude GNOME console in favor of ghostty
  environment.gnome.excludePackages = with pkgs; [
    gnome-console
  ];

  environment.systemPackages =
    with pkgs;
    [
      # gnome-extension-manager disabled temporarily due to https://github.com/NixOS/nixpkgs/issues/368664
      gnome-tweaks
      wl-clipboard # command line clipboard tool
    ]
    # include dock and menu as default
    ++ (with gnomeExtensions; [
      appindicator
      arcmenu
      dash-to-dock
    ]);

  # default GNOME settings
  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = [
              pkgs.gnomeExtensions.appindicator.extensionUuid
              pkgs.gnomeExtensions.arcmenu.extensionUuid
              pkgs.gnomeExtensions.dash-to-dock.extensionUuid
            ];
          };
        };
      }
    ];
  };

  # disabled due to "Open in Terminal" feature already provided by other packages
  # programs.nautilus-open-any-terminal = {
  #   enable = true;
  #   terminal = "ghostty";
  # };

  # theming for non GTK apps
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  services.dbus.packages = [ pkgs.gcr ]; # for gpg agent setup with gnome
  services.gnome.gnome-browser-connector.enable = true;

  # enable GNOME services
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # Enable GNOME Remote Desktop
  # https://github.com/NixOS/nixpkgs/issues/361163
  systemd.services.gnome-remote-desktop = {
    wantedBy = [ "graphical.target" ];
  };

  xdg.portal.enable = true;

}
