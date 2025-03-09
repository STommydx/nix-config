{ ... }:

{
  imports = [
    ./gnome.nix
    ./style.nix
  ];

  fonts.fontconfig.enable = true;

  # More "universal" way to set profile picture
  # This is the only way to set profile picture in GNOME declaratively,
  # instructed in NixOS wiki
  # https://wiki.nixos.org/wiki/GNOME#Change_user's_profile_picture
  home.file.".face".source = ./assets/propic.jpg;

  # Firefox settings are managed by online sync
  programs.firefox.enable = true;

  # ghostty Terminal settings
  programs.ghostty = {
    enable = true;
    settings = {
      background-opacity = 0.8;
      background-blur-radius = 20; # as recommended by author
      font-family = "MesloLGM Nerd Font";
      theme = "tokyonight";
    };
  };

  # Yubikey for PAM authentication
  # Generated with: pamu2fcfg -o pam://auth.stdx.space -i pam://auth.stdx.space > secrets/u2f_keys
  xdg.configFile."Yubico/u2f_keys".source = ./secrets/u2f_keys;

}
