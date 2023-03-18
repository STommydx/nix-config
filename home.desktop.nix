{ config, pkgs, lib, ... }:

with lib.hm.gvariant;

{

  imports = [ ./home.nix ];

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us+colemak" ]) (mkTuple [ "xkb" "us" ]) ];
    };
    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
    };
    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize:appmenu";
    };
    "org/gnome/mutter" = {
      check-alive-timeout = mkUint32 30000;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [ "gsconnect@andyholmes.github.io" "user-theme@gnome-shell-extensions.gcampax.github.com" "dash-to-dock@micxgx.gmail.com" "arcmenu@arcmenu.com" "blur-my-shell@aunetx" "appindicatorsupport@rgcjonas.gmail.com" ];
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Terminal.desktop"
        "org.gnome.Nautilus.desktop"
        "signal-desktop.desktop"
        "discord.desktop"
        "spotify.desktop"
      ];
    };
    "org/gnome/shell/extensions/arcmenu" = {
      distro-icon = 0;
      menu-layout = "Redmond";
      menu-button-appearance = "Icon_Text";
      menu-button-icon = "Distro_Icon";
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = false;
      click-action = "minimize-or-previews";
      custom-theme-shrink = true;
      dash-max-icon-size = 40;
      dock-position = "BOTTOM";
      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
      running-indicator-dominant-color = true;
      running-indicator-style = "CILIORA";
      show-favorites = true;
      show-mounts = false;
      show-trash = false;
    };
    "org/gnome/shell/weather" = {
      automatic-location = true;
      locations = "[<(uint32 2, <('Hong Kong', 'VHHH', true, [(0.38979019379430269, 1.9928751117510946)], [(0.38949931722116538, 1.9928751117510946)])>)>]";
    };
  };

  home.file.".face".source = ./assets/propic.jpg;

  home.packages = with pkgs; (
    with gnomeExtensions; [
      appindicator
      arcmenu
      blur-my-shell
      dash-to-dock
      gsconnect
    ]
  );

  programs.firefox.enable = true;
  programs.gnome-terminal = {
    enable = true;
    profile."842ec37e-9d77-4e26-86c5-41fc3bca62c5" = {
      default = true;
      visibleName = "Default";
      transparencyPercent = 20;
    };
  };
  programs.mangohud = {
    enable = true;
    settings = {
      gpu_stats = true;
      gpu_temp = true;
      gpu_load_change = true;
      cpu_stats = true;
      cpu_temp = true;
      cpu_load_change = true;
      core_load_change = true;
      vram = true;
      ram = true;
      fps = true;
      gamemode = true;
      no_display = true;
      position = "top-left";
      toggle_hud = "Shift_R+F12";
    };
  };
  programs.mpv.enable = true;
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      input-overlay
      obs-pipewire-audio-capture
      obs-vkcapture
    ];
  };
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
      golang.go
      hashicorp.terraform
      jnoortheen.nix-ide
      ms-azuretools.vscode-docker
      ms-vscode.cmake-tools
      ms-vscode.cpptools
      ms-vscode.makefile-tools
      ms-vscode-remote.remote-ssh
      redhat.vscode-yaml
      tomoki1207.pdf
    ];
    userSettings = {
      "editor.rulers" = [ 120 ];
      "explicitFolding.rules" = {
        "*" = {
          begin = "{{{";
          end = "}}}";
          autoFold = true;
        };
      };
      "git.confirmSync" = false;
      "remote.autoForwardPorts" = false;
      "terminal.integrated.fontFamily" = "MesloLGM Nerd Font Mono, DroidSansMono Nerd Font Mono, monospace";
      "vscode-neovim.neovimInitVimPaths.linux" = "${config.home.homeDirectory}/${config.xdg.configFile."vscode-neovim/init.lua".target}";
      "vscode-neovim.mouseSelectionStartVisualMode" = true;
      "workbench.colorTheme" = "Tokyo Night";
    };
  };
  programs.zsh.shellAliases = {
    pbcopy = "wl-copy";
    pbpaste = "wl-paste";
  };

  qt.platformTheme = "gnome";

  services.gnome-keyring.enable = true;

  xdg.configFile."vscode-neovim/init.lua".text = ''
    require("Comment").setup{}
    vim.keymap.set("v", "<C-c>", "\"+y", {noremap=true})
    vim.keymap.set("v", "<C-x>", "\"+d", {noremap=true})
  '';
  # pamu2fcfg -o pam://auth.stdx.space -i pam://auth.stdx.space > secrets/u2f_keys
  xdg.configFile."Yubico/u2f_keys".source = ./secrets/u2f_keys;
}
